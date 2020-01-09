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
      }

      template {
        data = <<EOH
          some_var = {{ key "not/existing/key" }}
        EOH

        destination = "templates/some_template.ini"
      }

      resources {
        cpu    = 200
        memory = 100
      }

      service {
        name = "nginx"
      }
    }
  }
}
