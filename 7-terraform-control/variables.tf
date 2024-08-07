###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}


###ssh vars
variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

###VMs resources
variable "image_os_family" {
  type        = string
  description = "OS family from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default     = "ubuntu-2004-lts-oslogin"
}
variable "vms_resources" {
  type = map(object({
    name : string,
    platform_id : string,
    cores : number,
    memory : number,
    core_fraction : number,
    preemptible : bool,
    hdd_size : number,
    hdd_type : string,
    enable_nat : bool,
  }))
  description = "{name=<STRING>, platform_id=<STRING>, cores=<NUMBER>, memory=<NUMBER>, core_fraction=<NUMBER>, vm_db_preemptible: <BOOL>, hdd_size=<NUMBER>, hdd_type=<STRING>, enable_nat: <BOOL>}"
  default = {
    web = {
      name          = "web"
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      hdd_size      = 10
      hdd_type      = "network-hdd"
      enable_nat    = true
    },
    main = {
      name          = "main"
      platform_id   = "standard-v1"
      cores         = 2
      memory        = 2
      core_fraction = 5
      preemptible   = true
      hdd_size      = 10
      hdd_type      = "network-hdd"
      enable_nat    = true
    },
    replica = {
      name          = "replica"
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      hdd_size      = 10
      hdd_type      = "network-hdd"
      enable_nat    = true
    },
  }
}