output "NAT" {
  value = {
    external = "ssh -o 'StrictHostKeyChecking=no' ${var.vms_ssh_user}@${yandex_compute_instance.nat_instance.network_interface[0].nat_ip_address}",
    internal = yandex_compute_instance.nat_instance.network_interface[0].ip_address
  }
}

output "Public" {
  value = [for s in yandex_compute_instance.vm_public_server : {
    external = "ssh -o 'StrictHostKeyChecking=no' ${var.vms_ssh_user}@${s.network_interface[0].nat_ip_address}",
    internal = s.network_interface[0].ip_address
  }]
}
output "Private" {
  value = [for s in yandex_compute_instance.vm_private_server : {
    internal = s.network_interface[0].ip_address
  }]
}
