###vm vars
variable "vm_db_prefix" {
  type = string
  description = "VM name prefix"
  default = "vmdb"
}

variable "vm_db_os_family" {
  type = string
  description = "OS family from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default = "ubuntu-2004-lts-oslogin"
}

variable "vm_db_name" {
  type = string
  description = "VM name"
  default = "platform-db"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "VM zone"
}

variable "vm_db_subnet_name" {
  type        = string
  default     = "develop_db_b"
  description = "VPC subnet name"
}

variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_platform_id" {
  type = string
  description = "VM CPU platform {standard-v1, standard-v2, standard-v3}"
  default = "standard-v3"
}

variable "vm_db_resources" {
  type = object({
    core_fraction: number,
    cores: number,
    memory: number,
})
  description = "{cores=<NUMBER>, memory=<NUMBER>, core_fraction=<NUMBER>}"
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm_db_resources_cores" {
  type = number
  description = "Number of cores CPU in VM"
  default = 2
}

variable "vm_db_resources_core_fraction" {
  type = number
  description = "Percentage of cpu using (up to 100) in VM"
  default = 20
}

variable "vm_db_resources_memory" {
  type = number
  description = "RAM memory size GBs in VM"
  default = 2
}

variable "vm_db_preemptible" {
  type = bool
  description = "Прерываемая ВМ (может выключаться и не гарантирует вычислительную производительность)"
  default = true
}

variable "vm_db_enable_nat" {
  type = bool
  description = "Включение NAT для выхода в сеть Интернет с внешнего IP-адреса"
  default = true
}