#######################################
# СЕТЬ
#######################################
## Основная сеть
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}
## Подсеть PUBLIC
resource "yandex_vpc_subnet" "public" {
  name           = var.subnet_public_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.subnet_public_cidr != null ? var.subnet_public_cidr : var.default_cidr
}


#######################################
# BUCKET
#######################################
## Создание ссылки
resource "yandex_storage_bucket" "bucket" {
  bucket = "${var.bucket_name}-${formatdate("YYYYMMDD", timestamp())}"
  anonymous_access_flags {
    read = true
  }
  # удаляем, даже если не пустой
  force_destroy = true
}
## Загрузка файла в бакет
resource "yandex_storage_object" "content" {
  bucket = yandex_storage_bucket.bucket.bucket
  key    = var.bucket_file_key
  source = var.bucket_file
}
## Загрузка картинки в бакет
resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.bucket.bucket
  key    = var.bucket_image_key
  source = var.bucket_image
}
#######################################
# VM GROUP
#######################################
## Образ загрузочного диска
data "yandex_compute_image" "boot" {
  family   = var.boot_os_family != "" ? var.boot_os_family : ""
  image_id = var.boot_image != "" ? var.boot_image : ""
}
## Сама группа
resource "yandex_compute_instance_group" "vm-group" {
  name               = var.vm_group_name
  service_account_id = var.service_account_id
  instance_template {
    name        = "${var.vm_group_name}-{instance.index}"
    hostname    = "${var.vm_group_name}-{instance.index}"
    platform_id = var.vms_resources["server"].platform_id
    resources {
      memory        = var.vms_resources["server"].memory
      cores         = var.vms_resources["server"].cores
      core_fraction = var.vms_resources["server"].core_fraction
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.boot.id
        size     = var.vms_resources["server"].hdd_size
        type     = var.vms_resources["server"].hdd_type
      }
    }
    scheduling_policy {
      preemptible = var.vms_resources["server"].preemptible
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = var.vms_resources["server"].enable_nat
    }

    #metadata = local.vms_metadata_public_image
    # Метаданные с пользовательским скриптом
    metadata = {
      serial_port_enable = "1",
      ssh_keys           = "${var.vms_ssh_user}:${var.vms_ssh_root_key}"
      user-data          = <<-EOT
        #!/bin/bash
        echo "<html><body><img src='https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/${yandex_storage_object.image.key}'></body></html>" > /var/www/html/index.html
        EOT
    }
  }

  scale_policy {
    fixed_scale {
      size = var.vm_group_scale_count
    }
  }
  allocation_policy {
    zones = [var.default_zone]
  }
  deploy_policy {
    max_unavailable = var.vm_group_max_unavailable
    max_expansion   = var.vm_group_max_expansion
    max_creating    = var.vm_group_max_creating
    max_deleting    = var.vm_group_max_deleting
  }
  health_check {
    interval = var.vm_group_healthcheck_interval
    timeout  = var.vm_group_healthcheck_timeout
    http_options {
      port = 80
      path = "/"
    }
  }
  load_balancer {
    target_group_name = var.vm_group_name
  }
}

#######################################
# NETWORK LOAD BALANCER
#######################################
resource "yandex_lb_network_load_balancer" "net-balancer" {
  name = var.net_balancer_name

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.vm-group.load_balancer[0].target_group_id

    healthcheck {
      name                = "http"
      interval            = 2
      timeout             = 1
      unhealthy_threshold = 2
      healthy_threshold   = 5
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

#######################################
# APPLICATION LOAD BALANCER
#######################################
# Целевая группа для балансировщика нагрузки. 
# Содержит список целевых экземпляров, на которые будет распределяться трафик. 
# Группа автоматически обновляется при изменении состава instance group.
resource "yandex_alb_target_group" "app-balancer-group" {
  name = "app-balancer-group"

  # Динамическое создание таргетов на основе экземпляров в группе VM-group
  dynamic "target" {
    # Итерация по всем экземплярам в compute instance group
    for_each = yandex_compute_instance_group.vm-group.instances
    content {
      # Использование общей подсети для всех экземпляров
      subnet_id = yandex_vpc_subnet.public.id
      # Получение внутреннего IP-адреса экземпляра из network interface
      ip_address = target.value.network_interface[0].ip_address
    }
  }
  # Явное указание зависимости для корректной последовательности создания ресурсов
  depends_on = [
    yandex_compute_instance_group.vm-group
  ]
}

# Бэкенд группа определяет параметры балансировки трафика и проверки состояния инстансов
resource "yandex_alb_backend_group" "backend-group" {
  name = var.backend_balancer_name
  # Включение привязки сессии к IP-адресу клиента для сохранения состояния
  session_affinity {
    connection {
      source_ip = true
    }
  }

  # Конфигурация HTTP-бэкенда
  http_backend {
    name   = "http-backend"
    weight = 1  # Вес для балансировки (при наличии нескольких бэкендов)
    port   = 80 # Порт целевых инстансов
    # Связь с целевой группой
    target_group_ids = [yandex_alb_target_group.app-balancer-group.id]
    # Конфигурация балансировки нагрузки
    load_balancing_config {
      panic_threshold = 90 # Порог для перехода в аварийный режим (% недоступных бэкендов)
    }
    # Настройки проверки инстансов
    healthcheck {
      timeout             = "10s" # Максимальное время ожидания ответа
      interval            = "2s"  # Интервал между проверками
      healthy_threshold   = 10    # Число успешных проверок для признания работоспособности
      unhealthy_threshold = 15    # Число неудачных проверок для признания неработоспособности
      http_healthcheck {
        path = "/" # URL для проверки здоровья
      }
    }
  }

  # Зависимость от создания целевой группы
  depends_on = [
    yandex_alb_target_group.app-balancer-group
  ]
}

# HTTP-роутер для управления маршрутизацией запросов
resource "yandex_alb_http_router" "http-router" {
  name = var.http_router_name
}

# Виртуальный хост для обработки входящих запросов
resource "yandex_alb_virtual_host" "app-balancer-host" {
  name           = "app-balancer-host"
  http_router_id = yandex_alb_http_router.http-router.id

  # Правило маршрутизации для всех HTTP-запросов
  route {
    name = "route-http"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id # Связь с бэкенд-группой
        timeout          = "60s"                                     # Таймаут обработки запроса
      }
    }
  }

  # Зависимость от создания бэкенд-группы
  depends_on = [
    yandex_alb_backend_group.backend-group
  ]
}

# Основной ресурс Application Load Balancer
resource "yandex_alb_load_balancer" "app-balancer" {
  name       = var.app_balancer_name
  network_id = yandex_vpc_network.vpc.id # Идентификатор облачной сети

  # Политика распределения ресурсов балансировщика
  allocation_policy {
    location {
      zone_id   = var.default_zone            # Зона доступности
      subnet_id = yandex_vpc_subnet.public.id # Рабочая подсеть
    }
  }

  # Конфигурация обработчика входящих запросов
  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {} # Автоматическое выделение публичного IPv4
      }
      ports = [80] # Прослушивание HTTP-порта
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id # Привязка HTTP-роутера
      }
    }
  }

  # Зависимость от создания HTTP-роутера
  depends_on = [
    yandex_alb_http_router.http-router
  ]
}
