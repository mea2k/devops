#######################################
# Yandex.cloud NETWORK VARS
#######################################
vpc_name            = "netology"
subnet_public_cidr  = ["192.168.10.0/24"]
subnet_private_cidr = ["192.168.20.0/24"]

#######################################
# Yandex.cloud BUCKET
#######################################
bucket_name      = "myfirstbucket"
bucket_file_key  = "index.html"
bucket_file      = "../data/index.html"
bucket_image_key = "image.png"
bucket_image     = "../data/image.png"

#######################################
# VM BOOT IMAGE
#######################################
boot_image = "fd827b91d99psvq5fjit"

#######################################
# VM GROUP
#######################################
vm_group_scale_count   = 3
vm_group_max_expansion = 1

#######################################
# VM vars
#######################################
vm_prefix    = "vm"
vm_name      = "server"
vms_ssh_user = "user"

vms_resources = {
  "server" = {
    platform_id   = "standard-v3"
    cores         = 2
    memory        = 2
    core_fraction = 20
    preemptible   = true
    hdd_size      = 10
    hdd_type      = "network-hdd"
    enable_nat    = true,
    ip_address    = "192.168.10.254"
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
    ip_address    = "192.168.10.254"
  },
}