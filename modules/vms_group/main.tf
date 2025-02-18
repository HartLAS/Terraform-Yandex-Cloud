module "manage_networks" {
  source        = "../networks"
  subnet_list   = var.subnet_list
  networks_list = var.networks_list
}

module "manage_disks" {
  source        = "../disks"
  vm_list       = var.vm_group_list
}

resource "yandex_compute_instance_group" "vms_group" {
  for_each            = var.vm_group_list
  name                = each.value["group_name"]
  service_account_id  = var.service_account_id
  deletion_protection = each.value["deletion_protection"]
  instance_template {
    platform_id = each.value["platform_id"]
    resources {
      memory        = each.value["ram"]
      cores         = each.value["cpu"]
      core_fraction = each.value["core_fraction"]
    }
    boot_disk {
      mode = each.value["boot_disk_mode"]
      initialize_params {
        image_id = each.value["template"]
        size     = each.value["boot_disk_size"]
      }
    }

    dynamic "network_interface" {
    for_each = each.value["network_interfaces"]

      content {
        subnet_ids = ["${module.manage_networks.subnets_info[network_interface.value.subnet].id}"]
        nat                = network_interface.value["public_ip"]
        ip_address         = "${network_interface.value["ipv4_addr"] != "" ? network_interface.value["ipv4_addr"] : ""}"
        nat_ip_address     = "${network_interface.value["nat_ip_address"] != "" ? network_interface.value["nat_ip_address"] : ""}"
        ipv6               = "${network_interface.value["ipv6"] != "" ? true : false}"
        ipv6_address       = "${network_interface.value["ipv6_address"] != "" ? network_interface.value["ipv6_address"] : ""}"
      }
    }

    metadata = {
      ssh-keys = jsonencode(var.private_ssh_keys)
    }

  }

  scale_policy {
    fixed_scale {
      size = each.value["fixed_scale"]
    }
  }

  allocation_policy {
    zones = [each.value.zone]
  }

  deploy_policy {
    max_unavailable = each.value.max_unavailable
    max_creating    = each.value.max_creating
    max_expansion   = each.value.max_expansion
    max_deleting    = each.value.max_deleting
  }
}