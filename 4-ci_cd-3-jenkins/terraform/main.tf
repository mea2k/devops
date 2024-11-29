# Описание элементов Yandex.Cloud
## Сеть
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}
## Подсеть
resource "yandex_vpc_subnet" "vpc_subnet_a" {
  name           = var.vm_subnet_name != null ? var.vm_subnet_name : "${var.platform_type}_subnet_a"
  zone           = var.vm_zone != null ? var.vm_zone : var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.vm_cidr != null ? var.vm_cidr : var.default_cidr
}

## Образ загрузочного диска
data "yandex_compute_image" "boot" {
  family = var.vm_os_family
}




