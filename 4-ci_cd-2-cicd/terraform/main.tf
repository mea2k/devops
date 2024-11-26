# Описание элементов Yandex.Cloud
## Сеть
resource "yandex_vpc_network" "cicd" {
  name = var.vpc_name
}
## Подсеть
resource "yandex_vpc_subnet" "cicd_subnet_a" {
  name           = var.vm_subnet_name != null ? var.vm_subnet_name : "${var.platform_type}_subnet_a"
  zone           = var.vm_zone != null ? var.vm_zone : var.default_zone
  network_id     = yandex_vpc_network.cicd.id
  v4_cidr_blocks = var.vm_cidr != null ? var.vm_cidr : var.default_cidr
}

## Образ загрузочного диска
data "yandex_compute_image" "boot" {
  family    = var.vm_os_family
}


# Описание ВМ
## 2 ВМ типа "server" (см. variables.tf)
resource "yandex_compute_instance" "vm_server" {
  count = 2

  # из vms_resources берем элемент с именем 'server'
  name        = "${var.platform_type}-${var.vm_prefix}-${var.vm_name}-${count.index + 1}"
  hostname    = "${var.platform_type}-${var.vm_prefix}-${var.vm_name}-${count.index + 1}"
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
    subnet_id = yandex_vpc_subnet.cicd_subnet_a.id
    nat       = var.vms_resources["server"].enable_nat
  }
  # metadata = {
  #   serial-port-enable = local.vms_metadata.serial_port_enable #1
  #   ssh-keys           = local.vms_metadata.ssh_keys[0]        #"ubuntu:${var.vms_ssh_root_key}"
  # }
  metadata = local.vms_metadata_public_image
}


# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      vm_hosts = yandex_compute_instance.vm_server
      vm_children = [{
        name: "sonarqube",
        hosts: [{
          name: yandex_compute_instance.vm_server[0].name
        }]
        }, {
        name: "nexus",
        hosts: [{
          name: yandex_compute_instance.vm_server[1].name
        }]
        }, {
        name: "postgres",
        hosts: [{
          name: yandex_compute_instance.vm_server[0].name
        }]
      }]
      ansible_user: var.vms_ssh_user
    }
  )
  filename = "${var.ansible_inventory_path}hosts.yml"
}











