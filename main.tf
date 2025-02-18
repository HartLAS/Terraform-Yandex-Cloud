module "manage_vms" {
  source           = "./modules/vms"
  vm_list          = var.virtual_machines
  subnet_list      = var.vms_subnets
  networks_list    = var.vms_networks
  private_ssh_keys = var.private_ssh_keys
  nlb_list         = var.nlbs
  single_vms_target_groups   = var.single_vms_target_groups
}

module "manage_vms_groups" {
    source             = "./modules/vms_group"
    vm_group_list      = var.virtual_machines_groups
    subnet_list        = var.groups_subnets
    networks_list      = var.groups_networks
    service_account_id = var.service_account_id
    private_ssh_keys   = var.private_ssh_keys
    nlb_list           = var.nlbs
}