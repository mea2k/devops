###vm vars
variable "vm_web_prefix" {
  type = string
  description = "VM name prefix"
  default = "vmweb"
}

variable "vm_web_os_family" {
  type = string
  description = "OS family from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default = "ubuntu-2004-lts-oslogin"
}

variable "vm_web_name" {
  type = string
  description = "VM name"
  default = "platform-web"
}

variable "vm_web_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "VM zone"
}

variable "vm_web_subnet_name" {
  type        = string
  default     = "develop_web_a"
  description = "VPC subnet name"
}

variable "vm_web_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

# variable "vm_web_platform_id" {
#   type = string
#   description = "VM CPU platform {standard-v1, standard-v2, standard-v3}"
#   default = "standard-v3"
# }

# variable "vm_web_resources" {
#   type = object({
#     core_fraction: number,
#     cores: number,
#     memory: number,
# })
#   description = "{cores=<NUMBER>, memory=<NUMBER>, core_fraction=<NUMBER>}"
#   default = {
#     cores         = 2
#     memory        = 1
#     core_fraction = 20
#   }
# }

# variable "vm_web_resources_cores" {
#   type = number
#   description = "Number of cores CPU in VM"
#   default = 2
# }

# variable "vm_web_resources_core_fraction" {
#   type = number
#   description = "Percentage of cpu using (up to 100) in VM"
#   default = 20
# }

# variable "vm_web_resources_memory" {
#   type = number
#   description = "RAM memory size GBs in VM"
#   default = 1
# }

# variable "vm_web_preemptible" {
#   type = bool
#   description = "Прерываемая ВМ (может выключаться и не гарантирует вычислительную производительность)"
#   default = true
# }

# variable "vm_web_enable_nat" {
#   type = bool
#   description = "Включение NAT для выхода в сеть Интернет с внешнего IP-адреса"
#   default = true
# }