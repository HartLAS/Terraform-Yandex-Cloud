output "boot_disks_info" {
  value = yandex_compute_disk.boot-disk
}

output "attached_disks_info" {
  value = yandex_compute_disk.attached-disk
}