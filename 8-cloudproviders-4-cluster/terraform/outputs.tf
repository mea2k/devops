output "Public" {
  value = [for s in yandex_vpc_subnet.public : {
    network = "${s.name}-${s.zone} [${s.v4_cidr_blocks[0]}]",
  }]
}

output "Private" {
  value = [for s in yandex_vpc_subnet.private : {
    network = "${s.name}-${s.zone} [${s.v4_cidr_blocks[0]}]",
  }]
}

output "Kubernetes_Nodegroups_status" {
  value = yandex_kubernetes_node_group.node_group.*.status
}

# output "Kubernetes_Nodes" {
#   value= [for s in yandex_kubernetes_node_group.node_group: {
#     external = "${s.instances.*.network_interface[0].nat_ip_address}",
#     internal = "${s.instances.*.network_interface[0].ip_address}",
#   }]
# }

