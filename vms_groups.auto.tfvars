virtual_machines_groups = {
    "group-demo" = {
      vm_name             = "" #Оставить пустым
      group_name          = "vms-group-demo" # Имя ВМ
      group_desc          = "Описание. Его видно только здесь"
      deletion_protection = false #Защита от удаления
      platform_id         = "standard-v3" #Платформа
      cpu                 = 2 # Кол-во ядер процессора
      core_fraction       = 20 #Утилизация процессора
      ram                 = 2 # Оперативная память в ГБ
      boot_disk_size      = 10 # Объем диска в ГБ
      boot_disk_mode      = "READ_WRITE" #Мод монтирование диска
      boot_disk_type      = "network-hdd" #Тип диска
      template            = "fd85bll745cg76f707mq" # ID образа ОС для использования
      zone = "ru-central1-a" #Зона
      network_interfaces = [
        {
          subnet             = "subnet-1"
          public_ip          = false
          ipv4_addr          = ""
          nat_ip_address     = ""
          ipv6               = ""
          ipv6_address       = ""
        },
        {
          subnet             = "subnet-2"
          public_ip          = true
          ipv4_addr          = ""
          mac_address        = ""
          nat_ip_address     = ""
          ipv6               = ""
          ipv6_address       = ""
        },
      ],
      secondary_disks = [
        {
          auto_delete = true
          name        = "disk_group_demo_attached"
          size        = 10
          type        = "network-hdd"
        },
        {
          auto_delete = true
          name        = "disk_group_demo_attached_second"
          size        = 20
          type        = "network-hdd"
        }
      ],
      fixed_scale = 3
      max_unavailable = 2
      max_creating    = 2
      max_expansion   = 2
      max_deleting    = 2
    }
}