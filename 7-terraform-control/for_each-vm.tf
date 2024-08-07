locals {
  # список объектов из vms_resources с именем 'main'
	vm_mains = [for object in var.vms_resources : object.name if object.name == "main"]

  # список объектов из vms_resources с именем 'replica'
  vm_replicas = [for object in var.vms_resources : object.name if object.name == "replica"]

  # объединяем два списка
  vm_db_names = toset(concat(local.vm_mains, local.vm_replicas))
}

resource "yandex_compute_instance" "vm_db" {
  for_each = local.vm_db_names

  name        = "${each.value}-${each.key}"
  hostname    = "${each.value}-${each.key}"
  platform_id = var.vms_resources[each.value].platform_id
  resources {
    cores         = var.vms_resources[each.value].cores
    memory        = var.vms_resources[each.value].memory
    core_fraction = var.vms_resources[each.value].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources[each.value].hdd_size
      type     = var.vms_resources[each.value].hdd_type
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources[each.value].preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vms_resources[each.value].enable_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = local.vms_metadata.serial_port_enable #1
    ssh-keys           = local.vms_metadata.ssh_keys[0]        #"ubuntu:${var.vms_ssh_root_key}"
  }
}

