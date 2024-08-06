resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop_subnet_a" {
  name           = var.vm_web_subnet_name
  zone           = var.vm_web_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_web_cidr
}

resource "yandex_vpc_subnet" "develop_subnet_b" {
  name           = var.vm_db_subnet_name
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_os_family
}
resource "yandex_compute_instance" "platform_web" {
  name        = local.vms_name["vm_web"] #var.vm_web_name
  hostname    = local.vms_name["vm_web"]
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_resources_cores
    memory        = var.vm_web_resources_memory
    core_fraction = var.vm_web_resources_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_subnet_a.id
    nat       = var.vm_web_enable_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vms_name["vm_db"]  #var.vm_db_name
  hostname    = local.vms_name["vm_db"]
  zone        = var.vm_db_zone
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_db_resources_cores
    memory        = var.vm_db_resources_memory
    core_fraction = var.vm_db_resources_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_subnet_b.id
    nat       = var.vm_db_enable_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
