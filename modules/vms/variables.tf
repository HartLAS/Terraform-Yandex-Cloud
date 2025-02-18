variable "vm_list" {
  description = "List of single VMs to create"
  type = map
  default = {}
}

variable "subnet_list" {
  description = "List of subnets for single VMs to create"
  type = map
  default = {}
}

variable "networks_list" {
  description = "List of subnets for single VMs to create"
  type = map
  default = {}
}

variable "private_ssh_keys" {
  description = "List of subnets for single VMs to create"
  type = list
  default = []
}

variable "nlb_list" {
  description = "List of NLB"
  type = map
  default = {}
}

variable "single_vms_target_groups" {
  description = "List of Target Groups for NLB"
  type = map
  default = {}
}