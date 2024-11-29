locals {


  # Метаданные для ВМ Yandex.CLoud
  # (добавление пользователя SUDO+SSH
  # (добавление ключа)
  ## формат только для Linux машин
  vms_metadata_linux_only = {
    serial_port_enable = 1,
    ssh_keys           = tolist(["${var.vms_ssh_user}:${var.vms_ssh_root_key}"])
  }

  ## формат для машин на базе публичных загрузочных образов ОС
  # (yc compute image list --folder=standard-images)
  vms_metadata_public_image = {
    "user-data" : "#cloud-config\nusers:\n  - name: ${var.vms_ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh_authorized_keys:\n      - ${var.vms_ssh_root_key}"
  }
}