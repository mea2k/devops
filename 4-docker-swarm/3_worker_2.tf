resource "yandex_compute_disk" "boot-disk-ubuntu20-3" {
  name     = "boot-disk-ubuntu20-3"
  type     = "network-hdd"
  zone     = var.yc_zone
  size     = "10"
  image_id = "fd8emsasqrpsp4lrem99" # Ubuntu 20 with OS Login
}


resource "yandex_compute_instance" "vm-3" {
  name        = "terraform-vm-3"
  hostname    = "worker-2"
  platform_id = "standard-v3" # Intel Ice Lake
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true  # прерываемая
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ubuntu20-3.id
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.terraform-1.id
    nat        = true
    ip_address = "192.168.201.13"
  }

  metadata = {
    #enable-oslogin=true
    user-data = "${file("./user-data")}"
  }

  provisioner "file" {
    source      = "./install_docker_machine_compose.sh"
    destination = "/tmp/install_docker_machine_compose.sh"

    connection {
      type        = "ssh"
      user = "terraform"
      private_key = file("../.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "3m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x  /tmp/install_docker_machine_compose.sh",
      "bash /tmp/install_docker_machine_compose.sh",
    ]
    connection {
      type        = "ssh"
      user = "terraform"
      private_key = file("../.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "2m30s"
    }
  }
}

output "internal_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.ip_address
}

output "external_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.nat_ip_address
}
