output "external_ips" {
  value = [for s in concat(yandex_compute_instance.vm_jenkins_master, yandex_compute_instance.vm_jenkins_agent) : {
    name = s.name,
    external = "ssh -o 'StrictHostKeyChecking=no' ${var.vms_ssh_user}@${s.network_interface[0].nat_ip_address}",
    internal = s.network_interface[0].ip_address
  }]
}

output "OS_family" {
  value = var.vm_os_family
}
