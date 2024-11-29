---
all:
  hosts:
%{ for vm in vm_hosts ~}
    ${vm.name}:
      ansible_host: ${vm.network_interface[0].nat_ip_address}
%{ endfor ~}
  children:
%{ for child in vm_children ~}
    ${child.name}:
      hosts:
%{ for host in child.hosts ~}
        ${host.name}:
%{ endfor ~}
%{ endfor ~}

  vars:
    ansible_connection_type: paramiko
    ansible_user: ${ansible_user}
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'