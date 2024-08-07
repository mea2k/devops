# locals {
#   # список объектов из vms_resources с именем 'web'
#   vm_web_resources = [for object in var.vms_resources : object if object.name == "web"]

#   # индекс найденного первого объекта из vm_web_resources в масссиве объектов vms_resources. 
#   # Если нет - то берем первый из vms_resources
#   vm_web_index = length(local.vm_web_resources) > 0 ? index(var.vms_resources, local.vm_web_resources[0]) : 0

# }

resource "yandex_compute_instance" "vm_web" {
  count = 2

  # из vms_resources берем элемент с именем 'web'
  name        = "${var.vms_resources["web"].name}-${count.index + 1}"
  hostname    = "${var.vms_resources["web"].name}-${count.index + 1}"
  platform_id = var.vms_resources["web"].platform_id
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["web"].hdd_size
      type     = var.vms_resources["web"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources["web"].preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vms_resources["web"].enable_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = local.vms_metadata.serial_port_enable #1
    ssh-keys           = local.vms_metadata.ssh_keys[0]        #"ubuntu:${var.vms_ssh_root_key}"
  }
  depends_on = [yandex_compute_instance.vm_db]
}