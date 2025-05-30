terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.8.4"
}

provider "yandex" {
  token = var.token
  #service_account_key_file = "key.json"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

provider "kubernetes" {
  config_path = "${path.module}/../kubernetes/kubeconfig.yaml"

}

provider "local" {}

