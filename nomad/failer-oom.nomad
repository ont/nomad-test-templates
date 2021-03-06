job "failer-oom" {
  meta {
    VERSION = "latest"
  }

  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "10s"
    max_parallel = 1
  }

  group "failer" {
    restart {
      attempts = 5
      interval = "30s"
      delay = "5s"
      mode = "delay"
    }

    task "failer" {
      driver = "docker"

      config {
        image = "localhost:5000/failer:${NOMAD_META_VERSION}"
        args = [
          "oom"
        ]
      }

      resources {
        cpu    = 200
        memory = 10
      }

      service {
        name = "failer"
      }
    }
  }
}
