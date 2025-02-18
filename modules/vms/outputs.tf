output "vm_info" {
  value = { for k, v in  yandex_compute_instance.virtual_machine : k => "${v.fqdn} ${v.name} ${v.network_interface.0.ip_address}"}
}