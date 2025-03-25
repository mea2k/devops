#######################################
# Yandex.cloud VARS
#######################################
vpc_name      = "netology"
subnet_public_cidr = ["192.168.10.0/24"]
subnet_private_cidr = ["192.168.20.0/24"]

#######################################
# VM vars
#######################################
vm_prefix     = "vm"
vm_name       = "server"
vms_ssh_user  = "user"

vms_resources = {
    "server" = {
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      hdd_size      = 10
      hdd_type      = "network-hdd"
      enable_nat    = true,
			ip_address		= "192.168.10.254"
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
			ip_address		= "192.168.10.254"
    },
}