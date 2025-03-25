#######################################
# Yandex.cloud SECRET VARS
#######################################
## token
variable "token" {
  type        = string
  description = "OAuth-token 'yc iam create-token' (https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token)"
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

#######################################
# Yandex.cloud VARS
#######################################
## default network name
variable "vpc_name" {
  type        = string
  description = "VPC network"
  default     = "develop"
}
## default network zone (used in yandex_vpc_subnet) - 'ru-central1-a'
variable "vpc_default_zone" {
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

#######################################
# Yandex.cloud NETWORK VARS
#######################################
variable "subnet_public_name" {
  type        = string
  description = "VPC public subnet name"
  default     = "public"
}
variable "subnet_public_cidr" {
  type        = list(string)
  description = "VPC public cidr (https://cloud.yandex.ru/docs/vpc/operations/subnet-create)"
  default     = ["10.0.1.0/24"]
}
variable "subnet_private_name" {
  type        = string
  description = "VPC private subnet name"
  default     = "private"
}
variable "subnet_private_cidr" {
  type        = list(string)
  description = "VPC private cidr (https://cloud.yandex.ru/docs/vpc/operations/subnet-create)"
  default     = ["10.0.2.0/24"]
}

variable "route_table_name" {
  type        = string
  description = "Routing table name (for NAT)"
  default     = "nat-instance-route"
}

#######################################
# VM vars
#######################################
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
## VM NAT name (used in VM name)
variable "vm_nat_name" {
  type        = string
  description = "VM NAT name"
  default     = "nat"
}
## VM OS family (used in yandex_compute_image)
variable "vm_os_family" {
  type        = string
  description = "OS family from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default     = "ubuntu-2004-lts"
}
## VM NAT OS family (used in yandex_compute_image)
variable "vm_nat_os_family" {
  type        = string
  description = "OS family for NAT from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default     = "nat-instance-ubuntu"
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
    enable_nat : bool,
    ip_address: string,
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
      enable_nat    = true,
      ip_address  = ""
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
