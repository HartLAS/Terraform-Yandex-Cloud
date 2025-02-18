resource "yandex_compute_instance" "virtual_machine" {
  for_each                  = var.vm_list
  name                      = each.value["vm_name"]
  zone                      = each.value["zone"]
  allow_stopping_for_update = each.value["allow_stopping_for_update"]
  platform_id               = each.value["platform_id"]
  hostname                  = each.value["vm_name"]

  resources {
    cores         = each.value["vm_cpu"]
    memory        = each.value["ram"]
    core_fraction = each.value["core_fraction"]
  }

  boot_disk {
    disk_id = module.manage_disks.boot_disks_info[each.key].id
  }

  dynamic "secondary_disk" {
    for_each = each.value["secondary_disks"]

    content {
      disk_id     = module.manage_disks.attached_disks_info[secondary_disk.value.name].id
      auto_delete = secondary_disk.value.auto_delete
    }
  }

  dynamic "network_interface" {
    for_each = each.value["network_interfaces"]

    content {
      subnet_id          = module.manage_networks.subnets_info[network_interface.value.subnet].id
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

module "manage_networks" {
  source        = "../networks"
  subnet_list   = var.subnet_list
  networks_list = var.networks_list
}

module "manage_disks" {
  source    = "../disks"
  vm_list   = var.vm_list
}

resource "yandex_lb_target_group" "lb_group" {
  for_each  = var.single_vms_target_groups
  name      = each.value.name
  region_id = each.value.region_id

  dynamic target {
    for_each = [for name in each.value["targets"] : name if yandex_compute_instance.virtual_machine[name.target_name] != ""]
    content {
      subnet_id = yandex_compute_instance.virtual_machine[target.value.target_name].network_interface.0.subnet_id
      address   = yandex_compute_instance.virtual_machine[target.value.target_name].network_interface.0.ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "nlb" {
  for_each = var.nlb_list
  name = each.value.name

  listener {
    name = "${each.value.name}-listener"
    port = each.value.listen_port
    external_address_spec {
      ip_version = each.value.ip_version
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.lb_group[each.value.target_group].id}"

    healthcheck {
      name = each.value.healtcheck_name
      http_options {
        port = each.value.healthcheck_port
        path = each.value.healthcheck_path
      }
    }
  }
}

