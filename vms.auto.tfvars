virtual_machines = {
    "vm-demo" = {
      vm_name        = "single-vm-demo" # Имя ВМ
      vm_desc        = "Описание. Его видно только здесь"
      vm_cpu         = 2 # Кол-во ядер процессора
      ram            = 2 # Оперативная память в ГБ
      boot_disk_size = 10 # Объем диска в ГБ
      boot_disk_type = "network-hdd" #Тип диска
      template       = "fd85bll745cg76f707mq" # ID образа ОС для использования
      zone           = "ru-central1-a" #Зона
      core_fraction  = 20 #Утилизация процессора
      platform_id    = "standard-v3" #Платформа
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
          subnet    = "subnet-1"
          public_ip = true
          ipv4_addr = ""
          mac_address        = ""
          nat_ip_address     = ""
          ipv6               = ""
          ipv6_address       = ""
        },
      ],
      secondary_disks = [
        {
          auto_delete = true
          name        = "disk_demo_attached"
          size        = 10
          type        = "network-hdd"
        },
        {
          auto_delete = true
          name        = "disk_demo_attached_second"
          size        = 20
          type        = "network-hdd"
        }
      ]
      allow_stopping_for_update = false
    }
}