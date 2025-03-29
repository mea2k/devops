#######################################
# СЕТЬ
#######################################
## Основная сеть
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}
## Подсеть PUBLIC
## 3 шт в разных зонах
resource "yandex_vpc_subnet" "public" {
  count = var.vpc_zones_count

  name           = "${var.subnet_public_name}-${count.index}"
  zone           = var.vpc_zones[count.index]
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.subnet_public_cidr[count.index]]
}

## Подсеть PRIVATE
## 3 шт в разных зонах
resource "yandex_vpc_subnet" "private" {
  count = var.vpc_zones_count

  name           = "${var.subnet_private_name}-${count.index}"
  zone           = var.vpc_zones[count.index]
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.subnet_private_cidr[count.index]]
}

#######################################
# КЛАСТЕР MYSQL
#######################################
## Группа безопасности для MySQL
resource "yandex_vpc_security_group" "mysql_sg" {
  name       = var.mysql_securitygroup_name
  network_id = yandex_vpc_network.vpc.id

  ingress {
    description    = "MySQL"
    port           = var.mysql_port #3306
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
## Кластер MySQL
resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name        = var.mysql_cluster_name
  environment = var.mysql_environment
  network_id  = yandex_vpc_network.vpc.id
  version     = var.mysql_version
  # Чтобы можно было удалять через terraform
  deletion_protection = false
  # платформа
  resources {
    resource_preset_id = var.mysql_platform
    disk_type_id       = var.mysql_disk_type
    disk_size          = var.mysql_disk_size
  }
  # время технического обслуживания
  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 23
  }
  # время резервного копирования
  backup_window_start {
    hours   = 23
    minutes = 59
  }
  # создаем кластер на все подсети PRIVATE в разных зонах
  dynamic "host" {
    for_each = yandex_vpc_subnet.private
    content {
      zone             = host.value.zone
      subnet_id        = host.value.id
      assign_public_ip = false # зона PRIVATE
    }
  }

  security_group_ids = [yandex_vpc_security_group.mysql_sg.id]
}

#######################################
# БАЗА ДАННЫХ MYSQL
#######################################
## Сама БД
resource "yandex_mdb_mysql_database" "mysql_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = var.mysql_dbname
}
## Пользователь-администратор БД
resource "yandex_mdb_mysql_user" "mysql_user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = var.mysql_username
  password   = var.mysql_password

  permission {
    database_name = yandex_mdb_mysql_database.mysql_db.name
    roles         = ["ALL"]
  }
}


#######################################
# KUBERNETES - СЕРВИСНЫЙ АККАУНТ
#######################################
## Сервисный аккаунт
resource "yandex_iam_service_account" "k8s_sa" {
  name        = var.k8s_sa_name
  description = "Kubernetes service account"
}
## Предоставление роли Editor на текущий folder
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}
## Предоставление роли k8s.clusters.agent на текущий folder
resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}
## Предоставление роли vpc.publicAdmin на текущий folder
resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}
## Предоставление роли container-registry.images.puller на текущий folder
resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}
## Предоставление роли kms.keys.encrypterDecrypter на текущий folder
resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

#######################################
# KUBERNETES - КЛЮЧИ ШИФРОВАНИЯ
#######################################
## Ключ Yandex Key Management Service для шифрования важной информации, 
## используется в KUBERNETES-кластере
resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}
## Статический ключ доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}

#######################################
# KUBERNETES - КЛАСТЕР
#######################################
## Группа безопасности для Kubernetes
resource "yandex_vpc_security_group" "k8s_sg" {
  name       = var.k8s_securitygroup_name
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера Managed Service for Kubernetes и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера Managed Service for Kubernetes и сервисов."
    v4_cidr_blocks = var.subnet_public_cidr
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "ICMP"
    description    = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
## Кластер Kubernetes
resource "yandex_kubernetes_cluster" "regional_cluster" {
  name        = var.k8s_cluster_name
  description = "Regional Kubernetes cluster"
  network_id  = yandex_vpc_network.vpc.id

  master {
    dynamic "master_location" {
      for_each = yandex_vpc_subnet.public
      content {
        zone      = master_location.value.zone
        subnet_id = master_location.value.id
      }
    }
    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]

    maintenance_policy {
      auto_upgrade = true
      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_sa.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.editor,
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }


}

#######################################
# KUBERNETES - ГРУППА УЗЛОВ
#######################################
## 3 группы в разных зонах доступности
## из 1 узла каждая с расширением до 2-х
resource "yandex_kubernetes_node_group" "node_group" {
  count = var.vpc_zones_count

  cluster_id = yandex_kubernetes_cluster.regional_cluster.id
  name       = "${var.k8s_nodegroup_name}-${var.vpc_zones[count.index]}-${count.index}"
  # параметры масштабирования группы узлов
  scale_policy {
    auto_scale {
      min     = var.k8s_nodes_per_zone_min
      max     = var.k8s_nodes_per_zone_max
      initial = var.k8s_nodes_per_zone_min
    }
  }
  # шаблон параметров ВМ для узлов кластера
  instance_template {
    name        = "${var.k8s_nodegroup_name}-${var.vpc_zones[count.index]}-{instance.index}"
    platform_id = var.vms_resources["node"].platform_id
    resources {
      memory        = var.vms_resources["node"].memory
      cores         = var.vms_resources["node"].cores
      core_fraction = var.vms_resources["node"].core_fraction
    }
    boot_disk {
      size = var.vms_resources["node"].hdd_size
      type = var.vms_resources["node"].hdd_type
    }
    scheduling_policy {
      preemptible = var.vms_resources["node"].preemptible
    }
    network_interface {
      subnet_ids = [tolist(yandex_vpc_subnet.public)[count.index].id]
      nat        = var.vms_resources["node"].enable_nat
    }
    # тип контейнеров
    container_runtime {
      type = "containerd"
    }
    # данные о SSH доступе
    metadata = local.vms_metadata_public_image
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public[count.index].zone
    }
  }
  depends_on = [yandex_kubernetes_cluster.regional_cluster]
}




# # 10. Настройка kubectl
# provider "local" {}

# resource "local_file" "kubeconfig" {
#   filename = "${path.module}/kubeconfig.yaml"
#   content = templatefile("${path.module}/kubeconfig.tpl", {
#     endpoint       = yandex_kubernetes_cluster.regional_cluster.master[0].external_v4_endpoint
#     cluster_ca     = base64encode(yandex_kubernetes_cluster.regional_cluster.master[0].cluster_ca_certificate)
#     k8s_cluster_id = yandex_kubernetes_cluster.regional_cluster.id
#   })

# }

# provider "kubernetes" {
#   config_path = "${path.module}/kubeconfig.yaml"

# }

# resource "time_sleep" "wait_for_cluster" {
#   create_duration = "300s" # Увеличено время ожидания
#   depends_on      = [yandex_kubernetes_cluster.regional_cluster]
# }







# # 11. Приложение phpMyAdmin
# resource "kubernetes_deployment" "phpmyadmin" {
#   depends_on = [
#     time_sleep.wait_for_cluster,
#     yandex_mdb_mysql_cluster.mysql_cluster
#   ]

#   metadata {
#     name = "phpmyadmin"
#     labels = {
#       app = "phpmyadmin"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "phpmyadmin"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "phpmyadmin"
#         }
#       }

#       spec {
#         container {
#           name  = "phpmyadmin"
#           image = "phpmyadmin/phpmyadmin:latest"
#           port {
#             container_port = 80
#           }
#           env {
#             name  = "PMA_HOST"
#             value = yandex_mdb_mysql_cluster.mysql_cluster.host.0.fqdn
#           }
#           env {
#             name  = "PMA_PORT"
#             value = "3306"
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "phpmyadmin" {
#   metadata {
#     name = "phpmyadmin-service"
#   }

#   spec {
#     selector = {
#       app = kubernetes_deployment.phpmyadmin.metadata[0].labels.app
#     }
#     port {
#       port        = 80
#       target_port = 80
#     }
#     type = "LoadBalancer"
#   }

#   depends_on = [kubernetes_deployment.phpmyadmin]
# }






# # 1. Создание KMS-ключа для бакета
# resource "yandex_kms_symmetric_key" "bucket_key" {
#   name              = "bucket-encryption-key"
#   description       = "KMS key for encrypting bucket content"
#   default_algorithm = "AES_256"
#   rotation_period   = "8760h" # 365 дней
# }

# # 2. Создание статического ключа доступа
# resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
#   service_account_id = var.service_account_id
#   description        = "static access key for object storage"
# }




