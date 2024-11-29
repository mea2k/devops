#######################################
# Yandex.cloud vars
#######################################
## token
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
## cloud id
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
## cloud-folder id
variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
## default zone (ru-central1-a)
variable "default_zone" {
  type        = string
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
  default     = "ru-central1-a"
}
## default cidr
variable "default_cidr" {
  type        = list(string)
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
  default     = ["10.0.1.0/24"]
}
## default network name
variable "vpc_name" {
  type        = string
  description = "VPC network & subnet name"
  default     = "develop"
}


#######################################
# VM vars
#######################################
## platform type (used in VM name)
variable "platform_type" {
  type        = string
  description = "Platform type {'prod', 'dev'}"
  default     = "prod"
}
## VM name prefix (used in VM name)
variable "vm_prefix" {
  type        = string
  description = "VM name prefix"
  default     = "vm"
}
## VM name (used in VM name)
variable "vm_name" {
  type        = string
  description = "VM name"
  default     = ""
}
## VM OS family (used in yandex_compute_image)
variable "vm_os_family" {
  type        = string
  description = "OS family from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default     = "ubuntu-2004-lts"
}
## Network zone (used in yandex_vpc_subnet)
variable "vm_zone" {
  type        = string
  description = "VM zone"
  default     = null
}
## Network subnet name
variable "vm_subnet_name" {
  type        = string
  description = "VPC subnet name"
  default     = null
}
## VM cidr
variable "vm_cidr" {
  type        = list(string)
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
  default     = null
}
## VMs resources
variable "vms_resources" {
  type = map(object({
    platform_id : string,
    cores : number,
    memory : number,
    core_fraction : number,
    preemptible : bool,
    hdd_size : number,
    hdd_type : string,
    enable_nat : bool
  }))
  description = "{platform_id=<STRING>, cores=<NUMBER>, memory=<NUMBER>, core_fraction=<NUMBER>, vm_db_preemptible: <BOOL>, hdd_size=<NUMBER>, hdd_type=<STRING>, enable_nat: <BOOL>}"
  default = {
    "server" = {
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


#######################################
# SSH vars
#######################################
## ssh user
variable "vms_ssh_user" {
  type        = string
  description = "SSH user"
  default     = "user"
}
## ssh root-key
variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}


#######################################
# Ansible vars
#######################################
## Ansible inventory relative path
variable "ansible_inventory_path" {
  type        = string
  description = "Ansible inventory relative path (ended with '/')"
  default     = "./"
}
