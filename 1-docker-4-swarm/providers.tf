terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_iam_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

resource "yandex_organizationmanager_os_login_settings" "login_settings" {
  organization_id = var.yc_organization_id
  ssh_certificate_settings {
    enabled = true
  }
  user_ssh_key_settings {
    enabled               = true
    allow_manage_own_keys = true
  }
}

resource "yandex_organizationmanager_user_ssh_key" "user_ssh_key_ubuntu" {
  name            = "user_ssh_key_ubuntu"
  organization_id = var.yc_organization_id
  subject_id      = var.yc_user_id
  data            = var.yc_public_key_ubuntu
}
