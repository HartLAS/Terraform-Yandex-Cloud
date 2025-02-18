resource "yandex_vpc_network" "network" {
  for_each       = var.networks_list
  name           = each.value["name"]
}

resource "yandex_vpc_subnet" "subnet" {
  for_each       = var.subnet_list
  name           = each.value["name"]
  zone           = each.value["zone"]
  network_id     = yandex_vpc_network.network[each.value.network].id
  v4_cidr_blocks = each.value["v4_cidr_blocks"]
}