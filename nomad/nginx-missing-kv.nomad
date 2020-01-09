job "nginx-missing-kv" {
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
        image = "nginx:${NOMAD_META_VERSION}"

        port_map {
          port_80 = 80
        }
      }

      template {
        data = <<EOH
          some_var = {{ key "not/existing/key" }}
        EOH

      }

      resources {
        cpu    = 200
        memory = 100
        network {
          port "http" { static = 8888 }
        }
      }

      service {
        name = "nginx"
        port = "http"
        check {
          name     = "nginx-check"
          port     = "http"
          type     = "tcp"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
