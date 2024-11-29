vpc_name       = "jenkins"
vm_subnet_name = "jenkins_subnet_a"
vm_prefix      = "vm"
vm_name        = "jenkins"
vm_os_family   = "ubuntu-2004-lts"
vms_ssh_user   = "admin"
vm_cidr        = ["10.0.1.0/24"]

ansible_inventory_path = "../playbook/inventory/"