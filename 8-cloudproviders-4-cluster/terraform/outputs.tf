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

output "phpmyadmin_ip" {
  value = kubernetes_service.phpmyadmin.status.0.load_balancer.0.ingress.0.ip
}