# Описание ВМ
## 1 ВМ  "jenkins-master" типа "server" (см. variables.tf)
resource "yandex_compute_instance" "vm_jenkins_master" {
  count = 1

  # из vms_resources берем элемент с именем 'server'
  name        = "${var.platform_type}-${var.vm_prefix}-${var.vm_name}-master-${count.index + 1}"
  hostname    = "${var.platform_type}-${var.vm_prefix}-${var.vm_name}-master-${count.index + 1}"
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
    subnet_id = yandex_vpc_subnet.vpc_subnet_a.id
    nat       = var.vms_resources["server"].enable_nat
  }
  metadata = local.vms_metadata_public_image
}


## 2 ВМ  "jenkins-agent" типа "server" (см. variables.tf)
resource "yandex_compute_instance" "vm_jenkins_agent" {
  count = 2

  # из vms_resources берем элемент с именем 'server'
  name        = "${var.platform_type}-${var.vm_prefix}-${var.vm_name}-agent-${count.index + 1}"
  hostname    = "${var.platform_type}-${var.vm_prefix}-${var.vm_name}-agent-${count.index + 1}"
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
    subnet_id = yandex_vpc_subnet.vpc_subnet_a.id
    nat       = var.vms_resources["server"].enable_nat
  }
  metadata = local.vms_metadata_public_image
}

# Формируем файл inventory для Ansible
# из шаблона templates/hosts.tpl
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      vm_hosts = concat(
        yandex_compute_instance.vm_jenkins_master,
      yandex_compute_instance.vm_jenkins_agent)

      vm_children = [{
        name : "jenkins_master",
        hosts : [for s in yandex_compute_instance.vm_jenkins_master : s]
        }, {
        name : "jenkins_agent",
        hosts : [for s in yandex_compute_instance.vm_jenkins_agent : s]
      }]
      ansible_user : var.vms_ssh_user
    }
  )
  filename = "${var.ansible_inventory_path}hosts.yml"
}











