groups_networks = {
  "network-group-demo" = {
     name = "demo-group-network"
  },
}

groups_subnets = {
  "subnet-1" = {
    name = "subnet-group-demo"
    zone = "ru-central1-a"
    v4_cidr_blocks = ["192.168.1.0/24"]
    network        = "network-group-demo"
  },
  "subnet-2" = {
    name = "subnet-group-demo-2"
    zone = "ru-central1-a"
    v4_cidr_blocks = ["192.168.2.0/24"]
    network        = "network-group-demo"
  },
}