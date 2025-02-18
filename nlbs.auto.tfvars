nlbs = {
    "nlb-demo" = {
        name              = "demo-nlb"
        listen_port       = 8080
        ip_version        = "ipv4"
        target_group      = "nlb_target_group_demo"
        healtcheck_name   = "demo-health"
        healthcheck_port  = 8080
        healthcheck_path  = "/"
    }
}

single_vms_target_groups = {
    "nlb_target_group_demo" = {
        name = "demo-target"
        region_id = "ru-central1"
        targets = {
          "1" = {
            target_name = "vm-demo"
          }
        }
    }
}