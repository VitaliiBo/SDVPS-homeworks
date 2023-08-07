terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token = var.ya_token
  cloud_id = "b1g6lqgummp0f6chmuj5"
  folder_id = "b1g314opt7d3ef23cdo5"
  zone = "ru-central1-b"
}


resource "yandex_compute_instance_group" "ig-1" {
  name               = "fixed-ig-with-balancer"
  folder_id          = "b1g314opt7d3ef23cdo5"
  service_account_id = "aje588j85ib9mkgq92tm"
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd80eup4e4h7mmodr9d4"
      }
    }

    network_interface {
      network_id = "enpmu4bftnfuhpj92ibb"
      subnet_ids = ["${yandex_vpc_subnet.hw-subnet.id}"]
      nat       = true
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }
}




# resource "yandex_compute_instance" "vmachines" {
#   count = 2

#   name = "vm-hw4-${count.index}"
#   platform_id = "standard-v3"

#   hostname = "vm-hw4-${count.index}"

#   resources {
#     core_fraction = 20
#     cores  = 2
#     memory = 1
#   }

#   scheduling_policy {
#     preemptible = true
#   }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.hw-subnet.id
#     nat       = true
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd80eup4e4h7mmodr9d4"
#       size = 10
#     }
#   }

#   metadata = {
#     user-data = "${file("./meta.txt")}"
#   }

# }

resource "yandex_vpc_subnet" "hw-subnet" {
  name           = "hw-4-subnet"
  zone           = "ru-central1-b"
  network_id     = "enpmu4bftnfuhpj92ibb"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# resource "yandex_lb_target_group" "hw-target-group" {
#   name      = "hw-target-group"

#   target {
#     subnet_id = "${yandex_vpc_subnet.hw-subnet.id}"
#     address   = "${yandex_compute_instance.vmachines[0].network_interface.0.ip_address}"
#   }

#   target {
#     subnet_id = "${yandex_vpc_subnet.hw-subnet.id}"
#     address   = "${yandex_compute_instance.vmachines[1].network_interface.0.ip_address}"
#   }
# }

resource "yandex_lb_network_load_balancer" "load_balancer" {
  name = "my-network-load-balancer"

  listener {
    name = "hw-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    # target_group_id = "${yandex_lb_target_group.hw-target-group.id}"
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# output "external_ip_address_vm-1" {
#   value = yandex_compute_instance_group.ig-1[0].network_interface.0.nat_ip_address
# }
# output "external_ip_address_vm-2" {
#   value = yandex_compute_instance_group.ig-1[1].network_interface.0.nat_ip_address
# }
