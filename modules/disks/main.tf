locals {
  sub_disks = flatten([
    for vm_index, vm_info in var.vm_list : [
      for disk_info in vm_info.secondary_disks : {
        key         = vm_index
        name        = disk_info["name"]
        size        = disk_info["size"]
        auto_delete = disk_info["auto_delete"]
        type        = disk_info["type"]
        zone        = vm_info["zone"]
      }
    ]
  ])

  disks_id = [ for disk_inf in local.sub_disks : yandex_compute_disk.attached-disk[disk_inf.name].id ]
}

resource "yandex_compute_disk" "boot-disk" {
  for_each = var.vm_list
  name     = "${each.value.vm_name != "" ? each.value.vm_name : each.value.group_name}"
  type     = each.value["boot_disk_type"]
  zone     = each.value["zone"]
  size     = each.value["boot_disk_size"]
  image_id = each.value["template"]
}

resource "yandex_compute_disk" "attached-disk" {
  for_each = {
    for disk in local.sub_disks : "${disk.name}" => disk
  }
  name        = each.value["name"]
  type        = each.value["type"]
  zone        = each.value["zone"]
  size        = each.value["size"]
}

resource "yandex_compute_snapshot" "boot-disk-snapshot" {
  for_each = var.vm_list
  name     = "${each.value.vm_name}"
  source_disk_id = yandex_compute_disk.boot-disk[each.key].id 
}

resource "yandex_compute_snapshot" "attached-disk-snapshot" {
  for_each = {
    for disk in local.sub_disks : "${disk.name}" => disk
  }
  name     = "${each.value.name}"
  source_disk_id = yandex_compute_disk.attached-disk[each.key].id 
}

resource "yandex_compute_snapshot_schedule" "boot-disk-one_week_ttl_every_day" {
  for_each = var.vm_list
  name     = "${each.value.vm_name != "" ? "${each.value.vm_name}-every_day-1w_ttl" : "${each.value.group_name}-every_day-1w_ttl"}"

  schedule_policy {
        expression = "0 0 * * *" 
  }

  snapshot_count = 7 
  retention_period = "168h" 

  disk_ids = ["${yandex_compute_disk.boot-disk[each.key].id}"] 
  
  depends_on = [
    yandex_compute_disk.boot-disk,
    yandex_compute_snapshot.boot-disk-snapshot
  ]
}

resource "yandex_compute_snapshot_schedule" "attached-disk-one_week_ttl_every_day" {
  for_each = {
    for disk in local.sub_disks : "${disk.name}" => disk
  }
  name     = "${each.value.name}-every_day-1w_ttl"

  schedule_policy {
        expression = "0 0 * * *" 
  }

  snapshot_count = 7 
  retention_period = "168h" 

  disk_ids = local.disks_id

  depends_on = [
    yandex_compute_disk.attached-disk,
    yandex_compute_snapshot.attached-disk-snapshot
  ]
}