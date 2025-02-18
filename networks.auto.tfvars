vms_networks = {
  "network-1" = {
     name = "demo-network"
  },
}

vms_subnets = {
  "subnet-1" = {
    name = "subnet-demo"
    zone = "ru-central1-a"
    v4_cidr_blocks = ["192.168.1.0/24"]
    network        = "network-1"
  }
}