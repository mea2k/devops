resource "yandex_compute_disk" "boot-disk-ubuntu20" {
  name     = "boot-disk-ubuntu20-1"
  type     = "network-hdd"
  zone     = var.yc_zone
  size     = "10"
  image_id = "fd8emsasqrpsp4lrem99" # Ubuntu 20 with OS Login
}

resource "random_password" "rand_root_pwd" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "rand_user_pwd" {
  length      = 10
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "yandex_vpc_network" "terraform" {
  name      = "terraform"
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "terraform-1" {
  name           = "terraform-1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.terraform.id
  v4_cidr_blocks = ["192.168.201.0/24"]
}

resource "yandex_compute_instance" "docker-vm" {
  name        = "docker-vm"
  hostname    = "docker-vm"
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
    disk_id = yandex_compute_disk.boot-disk-ubuntu20.id
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.terraform-1.id
    nat        = true
    ip_address = "192.168.201.11"
  }

  metadata = {
    #enable-oslogin=true

    # file with ssh-keys
    user-data = "${file("./user-data")}"
  }

  provisioner "file" {
    source      = "./install_docker_machine_compose.sh"
    destination = "/tmp/install_docker_machine_compose.sh"
    
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("./.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "2m30s"
    }
  }

  provisioner "file" {
    content     = <<EOT
    MYSQL_ROOT_PASSWORD=${random_password.rand_root_pwd.result}
    MYSQL_DATABASE=wordpress
    MYSQL_USER=wordpress
    MYSQL_PASSWORD=${random_password.rand_user_pwd.result}
    MYSQL_ROOT_HOST=docker-vm
    EOT
    destination = "./.env"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("./.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "2m30s"
    }
  }


  provisioner "file" {
    source      = "./install_docker_machine_compose.sh"
    destination = "/tmp/install_docker_machine_compose.sh"

    connection {
      type        = "ssh"
      user        =  var.ssh_user
      private_key = file("./.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "2m30s"
    }
  }



  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x  /tmp/install_docker_machine_compose.sh",
      "bash /tmp/install_docker_machine_compose.sh",
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("./.ssh/id_ed25519")
      host        = self.network_interface.0.nat_ip_address
      agent = false
      timeout = "3m"
    }
  }
}

output "internal_ip_address" {
  value = yandex_compute_instance.docker-vm.network_interface.0.ip_address
}

output "external_ip_address" {
  value = yandex_compute_instance.docker-vm.network_interface.0.nat_ip_address
}

output "db_env" {
  value=<<EOT
    MYSQL_ROOT_PASSWORD=${random_password.rand_root_pwd.result}
    MYSQL_DATABASE=wordpress
    MYSQL_USER=wordpress
    MYSQL_PASSWORD=${random_password.rand_user_pwd.result}
    MYSQL_ROOT_HOST=${yandex_compute_instance.docker-vm.network_interface.0.nat_ip_address}
  EOT
  sensitive=true
}
