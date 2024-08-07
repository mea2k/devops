output "external_ips" {
  value = [
    { vm_web = [for obj in yandex_compute_instance.vm_web : { 
				external = "ssh -o 'StrictHostKeyChecking=no' ubuntu@${obj.network_interface[0].nat_ip_address}", 
				internal = obj.network_interface[0].ip_address
			}
		]
		},
		{ vm_db = [for obj in yandex_compute_instance.vm_db : { 
				external = "ssh -o 'StrictHostKeyChecking=no' ubuntu@${obj.network_interface[0].nat_ip_address}", 
				internal = obj.network_interface[0].ip_address
			}
		]}
	]
}

		

