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
  type        = string
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
  default     = "10.0.1.0/24"
}
## Number of zones
variable "vpc_zones_count" {
  type        = number
  description = "Number of zones for cluster"
  default     = 1
}
## List of zones
variable "vpc_zones" {
  type        = list(string)
  description = "List of zones (count must be equal to 'var.vpc_zones_count')"
  default     = ["ru-central1-a"]
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
## default PUBLIC net name
variable "subnet_public_name" {
  type        = string
  description = "VPC public subnet name"
  default     = "public"
}
## default PUBLIC net cidr
variable "subnet_public_cidr" {
  type        = list(string)
  description = "VPC public cidr (https://cloud.yandex.ru/docs/vpc/operations/subnet-create)"
  default     = ["10.1.1.0/24"]
}
## default PRIVATE net name
variable "subnet_private_name" {
  type        = string
  description = "VPC private subnet name"
  default     = "private"
}
## default PRIVATE net cidr
variable "subnet_private_cidr" {
  type        = list(string)
  description = "VPC private cidr (https://cloud.yandex.ru/docs/vpc/operations/subnet-create)"
  default     = ["10.2.1.0/24"]
}

#######################################
# MYSQL.CLUSTER VARS
#######################################
## security group name
variable "mysql_securitygroup_name" {
  type        = string
  description = "MySQL Security Group name"
  default     = "mysql-security-group"
}
## default MySQL port
variable "mysql_port" {
  type        = number
  description = "MySQL TCP-port"
  default     = 3306
}
## Mysql Cluster name
variable "mysql_cluster_name" {
  type        = string
  description = "MySQL Cluster name"
  default     = "mysql-cluster"
}
## MySQL environment {PRESTABLE|PRODUCTION}
variable "mysql_environment" {
  type        = string
  description = "MySQL Cluster environment {PRESTABLE|PRODUCTION}"
  default     = "PRODUCTION"
}
## MySQL version
variable "mysql_version" {
  type        = string
  description = "MySQL version (5.7 or 8.0)"
  default     = "8.0"
}
## MySQL resources preset name
variable "mysql_platform" {
  type        = string
  description = "MySQL platform (resources preset) name: 'yc mysql resource-preset list'"
}
## MySQL Disk type
variable "mysql_disk_type" {
  type        = string
  description = "MySQL disk type: 'yc compute disk-type list'"
  default     = "network-ssd"
}
## MySQL Disk size in Gb
variable "mysql_disk_size" {
  type        = number
  description = "MySQL disk size (in Gb)"
  default     = 20
}

#######################################
# MYSQL.DB VARS
#######################################
## MySQL Database name
variable "mysql_dbname" {
  type        = string
  description = "MySQL Database name"
  default     = "mysql-db"
}
## MySQL Database username
variable "mysql_username" {
  type        = string
  description = "MySQL Database username"
  default     = "user"
}
## MySQL Database password
variable "mysql_password" {
  type        = string
  description = "MySQL Database user password"
}

#######################################
# KUBERNETES VARS
#######################################
## Kubernetes service account name
variable "k8s_sa_name" {
  type        = string
  description = "Kubernetes service account name"
  default     = "k8s-service-account"
}
## security group name
variable "k8s_securitygroup_name" {
  type        = string
  description = "Kubernetes Security Group name"
  default     = "k8s-security-group"
}
## Kubernetes Cluster name
variable "k8s_cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "k8s-cluster"
}
## Kubernetes Cluster name
variable "k8s_nodegroup_name" {
  type        = string
  description = "Kubernetes nodes group name"
  default     = "node-group"
}
## Kubernetes Min number of Nodes per zone
variable "k8s_nodes_per_zone_min" {
  type        = number
  description = "Kubernetes Min number of Nodes per zone"
  default     = 1
}
## Kubernetes Max number of Nodes per zone
variable "k8s_nodes_per_zone_max" {
  type        = number
  description = "Kubernetes Max number of Nodes per zone"
  default     = 2
}

#######################################
# KUBERNETES NODES VARS
#######################################
## Node name
variable "k8s_node_name" {
  type        = string
  description = "K8s node name"
  default     = "node"
}
## Node resources
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
      hdd_size      = 20
      hdd_type      = "network-hdd"
      enable_nat    = true,
      ip_address    = ""
    },
    "node" = {
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 2
      core_fraction = 20
      preemptible   = true
      hdd_size      = 30
      hdd_type      = "network-hdd"
      enable_nat    = true,
      ip_address    = ""
    },
    "nat" = {
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      hdd_size      = 10
      hdd_type      = "network-hdd"
      enable_nat    = true
      ip_address    = ""
    },
  }
}


variable "vm_nat_os_family" {
  type        = string
  description = "OS family for NAT from Yandex.CLoud ('yc compute image list --folder-id standard-images')"
  default     = "nat-instance-ubuntu"
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
