# Описание элементов Yandex.Cloud
## Сеть
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}
## Подсеть PUBLIC
resource "yandex_vpc_subnet" "public" {
  name           = var.subnet_public_name
  zone           = var.vpc_default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.subnet_public_cidr != null ? var.subnet_public_cidr : var.default_cidr
}
## Подсеть PRIVATE
resource "yandex_vpc_subnet" "private" {
  name           = var.subnet_private_name
  zone           = var.vpc_default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.subnet_private_cidr != null ? var.subnet_private_cidr : var.default_cidr
  route_table_id = yandex_vpc_route_table.nat_route.id
}
## Таблица маршрутизации и статический маршрут
resource "yandex_vpc_route_table" "nat_route" {
  name       = var.route_table_name
  network_id = yandex_vpc_network.vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat_instance.network_interface.0.ip_address
  }
}

# NAT-instance
## Образ загрузочного диска
data "yandex_compute_image" "nat_boot" {
  family = var.vm_nat_os_family
}
## VM-NAT
resource "yandex_compute_instance" "nat_instance" {
  name        = "${var.vm_prefix}-${var.vm_nat_name}"
  hostname    = "${var.vm_prefix}-${var.vm_nat_name}"
  platform_id = var.vms_resources["nat"].platform_id
  resources {
    cores         = var.vms_resources["nat"].cores
    memory        = var.vms_resources["nat"].memory
    core_fraction = var.vms_resources["nat"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat_boot.id
      size     = var.vms_resources["nat"].hdd_size
      type     = var.vms_resources["nat"].hdd_type
    }
  }
  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  scheduling_policy {
    preemptible = var.vms_resources["nat"].preemptible
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = var.vms_resources["nat"].ip_address
    nat        = var.vms_resources["nat"].enable_nat
  }

  # metadata = {
  #   serial-port-enable = local.vms_metadata.serial_port_enable #1
  #   ssh-keys           = local.vms_metadata.ssh_keys[0]        #"ubuntu:${var.vms_ssh_root_key}"
  # }
  metadata = local.vms_metadata_public_image
}


# Описание ВМ
## Образ загрузочного диска
data "yandex_compute_image" "boot" {
  family = var.vm_os_family
}
## ВМ типа "server" (см. variables.tf) в PUBLIC
resource "yandex_compute_instance" "vm_public_server" {
  count = 1

  # из vms_resources берем элемент с именем 'server'
  name        = "${var.vm_prefix}-${var.vm_name}-public-${count.index + 1}"
  hostname    = "${var.vm_prefix}-${var.vm_name}-public-${count.index + 1}"
  platform_id = var.vms_resources["server"].platform_id
  resources {
    cores         = var.vms_resources["server"].cores
    memory        = var.vms_resources["server"].memory
    core_fraction = var.vms_resources["server"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.boot.id
      size     = var.vms_resources["server"].hdd_size
      type     = var.vms_resources["server"].hdd_type
    }
  }
  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  scheduling_policy {
    preemptible = var.vms_resources["server"].preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = var.vms_resources["server"].enable_nat
  }
  # metadata = {
  #   serial-port-enable = local.vms_metadata.serial_port_enable #1
  #   ssh-keys           = local.vms_metadata.ssh_keys[0]        #"ubuntu:${var.vms_ssh_root_key}"
  # }
  metadata = local.vms_metadata_public_image
}

## ВМ типа "server" (см. variables.tf) в PRIVATE
resource "yandex_compute_instance" "vm_private_server" {
  count = 1

  # из vms_resources берем элемент с именем 'server'
  name        = "${var.vm_prefix}-${var.vm_name}-private-${count.index + 1}"
  hostname    = "${var.vm_prefix}-${var.vm_name}-private-${count.index + 1}"
  platform_id = var.vms_resources["server"].platform_id
  resources {
    cores         = var.vms_resources["server"].cores
    memory        = var.vms_resources["server"].memory
    core_fraction = var.vms_resources["server"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.boot.id
      size     = var.vms_resources["server"].hdd_size
      type     = var.vms_resources["server"].hdd_type
    }
  }
  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  scheduling_policy {
    preemptible = var.vms_resources["server"].preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }
  # metadata = {
  #   serial-port-enable = local.vms_metadata.serial_port_enable #1
  #   ssh-keys           = local.vms_metadata.ssh_keys[0]        #"ubuntu:${var.vms_ssh_root_key}"
  # }
  metadata = local.vms_metadata_public_image
}











