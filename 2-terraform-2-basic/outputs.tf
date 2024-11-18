output "external_ips" {
  value = [
    { vm_web = {
				external = "ssh -o 'StrictHostKeyChecking=no' ubuntu@${yandex_compute_instance.platform_web.network_interface[0].nat_ip_address}", 
				internal = yandex_compute_instance.platform_web.network_interface[0].ip_address
			}
		},
		{ vm_db = {
				external = "ssh -o 'StrictHostKeyChecking=no' ubuntu@${yandex_compute_instance.platform_db.network_interface[0].nat_ip_address}", 
				internal = yandex_compute_instance.platform_db.network_interface[0].ip_address
			}
		}
	]
}
