#######################################
# Yandex.cloud DEFAULTS
#######################################
vpc_zones_count = 3
vpc_zones       = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

#######################################
# Yandex.cloud NETWORK VARS
#######################################
vpc_name            = "netology"
subnet_public_cidr  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
subnet_private_cidr = ["192.168.201.0/24", "192.168.202.0/24", "192.168.203.0/24"]

#######################################
# MYSQL.CLUSTER VARS
#######################################
mysql_cluster_name = "mysql-cluster"
mysql_environment  = "PRESTABLE"
mysql_version      = "8.0"
mysql_platform     = "b2.medium"
mysql_disk_type    = "network-ssd" #"network-ssd-nonreplicated"
mysql_disk_size    = 10

#######################################
# MYSQL.DB VARS
#######################################
mysql_dbname   = "netology_db"
mysql_username = "user"

#######################################
# KUBERNETES CLUSTER VARS
#######################################
k8s_cluster_name       = "k8s-regional-cluster"
k8s_nodes_per_zone_min = 1
k8s_nodes_per_zone_max = 2
