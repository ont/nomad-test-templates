job "nginx-local" {
  meta {
    VERSION = "latest"
  }

  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "10s"
    max_parallel = 1
  }

  group "nginx" {
    restart {
      attempts = 5
      interval = "30s"
      delay = "5s"
      mode = "delay"
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "localhost:5000/nginx:{{version}}"

        port_map {
          port_80 = 80
        }
      }

      template {
        data = <<EOH
            TEST_ME_VALUE=123
            MORE_LINES="for test"
            SOME_MORE="value"
        EOH
        destination = "configs/.env"
        change_mode = "restart"
      }

      resources {
        cpu    = 200
        memory = 110
        network {
          port "port_80" {}
        }
      }

      service {
        name = "nginx"
        port = "port_80"
        check {
          name     = "nginx-check"
          port     = "port_80"
          type     = "tcp"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
