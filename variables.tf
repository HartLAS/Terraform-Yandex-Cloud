variable "virtual_machines" {
  default = {}
  type    = map
}

variable "vms_subnets" {
  type    = map
  default = {}
}

variable "groups_subnets" {
  type    = map
  default = {}
}

variable "vms_networks" {
   type    = map
   default = {}
}

variable "groups_networks" {
   type    = map
   default = {}
}

variable "private_ssh_keys" {
   type = list
   default = [
    "hartlas:$${file('~/.ssh/id_ed25519.pub')}"
   ]
}

variable "virtual_machines_groups" {
  type    = map
  default = {}
}

variable "service_account_id" {
  type    = string
  default = "" #ID аккаунта, под которым будет выполняться развертывание
}

variable "nlbs" {
  type    = map
  default = {}
}

variable "single_vms_target_groups" {
  type    = map
  default = {}
}