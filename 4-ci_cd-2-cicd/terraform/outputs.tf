output "external_ips" {
  value = [for s in yandex_compute_instance.vm_server : {
    external = "ssh -o 'StrictHostKeyChecking=no' ${var.vms_ssh_user}@${s.network_interface[0].nat_ip_address}",
    internal = s.network_interface[0].ip_address
  }]
}

output "OS_family" {
	value = "${var.vm_os_family}"
}
