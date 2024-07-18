resource "yandex_vpc_network" "terraform" {
  name      = "terraform"
  folder_id = "b1g5fegelltrlo3noaai"
}

resource "yandex_vpc_subnet" "terraform-1" {
  name           = "terraform-1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.terraform.id
  v4_cidr_blocks = ["192.168.201.0/24"]
}

resource "yandex_compute_disk" "boot-disk-ubuntu20-1" {
  name     = "boot-disk-ubuntu20-1"
  type     = "network-hdd"
  zone     = var.yc_zone
  size     = "10"
  image_id = "fd8emsasqrpsp4lrem99" # Ubuntu 20 with OS Login
}


resource "yandex_compute_instance" "vm-1" {
  name        = "terraform-vm-1"
  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ubuntu20-1.id
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.terraform-1.id
    nat        = true
    ip_address = "192.168.201.11"
  }

  metadata = {
    enable-oslogin=true
    user-data = "${file("./user-data")}"
  }

  provisioner "file" {
    source      = "./install_docker_machine_compose.sh"
    destination = "/tmp/install_docker_machine_compose.sh"

    connection {
      type        = "ssh"
      user = "root"
      private_key = file("../.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x  /tmp/install_docker_machine_compose.sh",
      "sudo sh /tmp/install_docker_machine_compose.sh",
    ]
    connection {
      type        = "ssh"
      user = "root"
      private_key = file("../.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "2m"
    }
  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
