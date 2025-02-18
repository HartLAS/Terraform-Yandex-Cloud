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

variable "vm_group_list" {
  description = "List of groups of VMs to create"
  type = map
  default = {}
}

variable "service_account_id" {
  type      = string
  default   = ""
  sensitive = true
}

variable "nlb_list" {
  description = "List of NLB"
  type = map
  default = {}
}