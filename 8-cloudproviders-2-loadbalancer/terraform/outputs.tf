output "VMGroup" {
  value = [for s in yandex_compute_instance_group.vm-group.instances : {
    external = "ssh -o 'StrictHostKeyChecking=no' ${var.vms_ssh_user}@${s.network_interface[0].nat_ip_address}",
    internal = s.network_interface[0].ip_address
  }]
}


output "Network_Load_Balancer_Address" {
  value       = yandex_lb_network_load_balancer.net-balancer.listener.*.external_address_spec[0].*.address
  description = "Адрес NLB"
}


output "Application_Load_Balancer_Address" {
  value       = yandex_alb_load_balancer.app-balancer.listener.*.endpoint[0].*.address[0].*.external_ipv4_address
  description = "Адрес APL"
}