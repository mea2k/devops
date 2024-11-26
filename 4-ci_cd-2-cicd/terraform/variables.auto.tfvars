vpc_name      = "develop"
platform_type = "prod"
vm_prefix     = "vm"
vm_name       = "cicd"
vm_os_family  = "centos-7"
vms_ssh_user  = "admin"
vm_cidr       = ["10.0.1.0/24"]

ansible_inventory_path = "../playbook/inventory/" #"../playbook/inventory/cicd/"