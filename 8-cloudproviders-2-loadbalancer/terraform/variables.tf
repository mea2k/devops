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
## service_account id
variable "service_account_id" {
  type        = string
  description = "'yc iam service-account list'"
}

#######################################
# Yandex.cloud DEFAULTS
#######################################
## default network zone (used in yandex_vpc_subnet) - 'ru-central1-a'
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

#######################################
# Yandex.cloud BUCKET
#######################################
## bucket name
variable "bucket_name" {
  type        = string
  description = "Bucket name to create"
}
## bucket file key
variable "bucket_file_key" {
  type        = string
  description = "Bucket key"
  default     = ""
}
## bucket file
variable "bucket_file" {
  type        = string
  description = "Bucket filename"
  default     = ""
}
## bucket image key
variable "bucket_image_key" {
  type        = string
  description = "Bucket key"
}
## bucket image file
variable "bucket_image" {
  type        = string
  description = "Bucket filename"
}


#######################################
# Yandex.cloud NETWORK VARS
#######################################
## default network name
variable "vpc_name" {
  type        = string
  description = "VPC network"
  default     = "develop"
}
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

#######################################
# VM GROUP
#######################################
variable "vm_group_name" {
  type        = string
  description = "VM Group name"
  default     = "vm-group"
}
variable "vm_group_scale_count" {
  type        = number
  description = "VM Group scale count"
  default     = 2
}
variable "vm_group_max_unavailable" {
  type        = number
  description = "VM Group max unavailable"
  default     = 1
}
variable "vm_group_max_expansion" {
  type        = number
  description = "VM Group max expansion above max size"
  default     = 1
}
variable "vm_group_max_creating" {
  type        = number
  description = "VM Group max creating VMs at a moment"
  default     = 1
}
variable "vm_group_max_deleting" {
  type        = number
  description = "VM Group max deletimg VMs at a moment"
  default     = 1
}
variable "vm_group_healthcheck_interval" {
  type        = number
  description = "VM Group healthcheck interval in seconds"
  default     = 15
}
variable "vm_group_healthcheck_timeout" {
  type        = number
  description = "VM Group healthcheck timeout in seconds"
  default     = 5
}


#######################################
# LOAD BALANCER
#######################################
## Network load balancer
variable "net_balancer_name" {
  type        = string
  description = "Network load balancer name"
  default     = "net-balancer"
}
## Application load balancer
variable "app_balancer_name" {
  type        = string
  description = "Application load balancer name"
  default     = "app-balancer"
}
## Application backend balancer
variable "backend_balancer_name" {
  type        = string
  description = "Application backend balancer name"
  default     = "backend-balancer"
}
## HTTP-router for backend-balancer
variable "http_router_name" {
  type        = string
  description = "HTTP-router for backend-balancer name"
  default     = "http-router"
}


#######################################
# VM BOOT IMAGE
#######################################
## VM OS family (used in yandex_compute_image)
variable "boot_os_family" {
  type        = string
  description = "OS family from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default     = ""
}
## VM OS image_id (used in yandex_compute_image)
variable "boot_image" {
  type        = string
  description = "OS image id from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default     = ""
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
    ip_address : string,
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
      ip_address    = ""
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
