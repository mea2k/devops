resource "yandex_compute_disk" "vdisk" {
  count = 3

  name = "vdisk-${count.index + 1}"
  type = "network-hdd"
  zone = var.default_zone
  size = "1"
}


resource "yandex_compute_instance" "vm_storage" {
  name        = var.vms_resources["storage"].name
  hostname    = var.vms_resources["storage"].name
  platform_id = var.vms_resources["storage"].platform_id
  resources {
    cores         = var.vms_resources["storage"].cores
    memory        = var.vms_resources["storage"].memory
    core_fraction = var.vms_resources["storage"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["storage"].hdd_size
      type     = var.vms_resources["storage"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources["storage"].preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vms_resources["storage"].enable_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = local.vms_metadata.serial_port_enable #1
    ssh-keys           = local.vms_metadata.ssh_keys[0]        #"ubuntu:${var.vms_ssh_root_key}"
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.vdisk

    content {
      disk_id     = lookup(secondary_disk.value, "id", null)
      auto_delete = true
    }
  }
}