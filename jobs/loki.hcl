# Loki job definition for Nomad

job "loki" {
  datacenters = ["dc1"]
  type        = "service"

  group "logging" {
    count = 1

    network {
      port "http" {
        static = 3100
      }
    }

    task "loki" {
      driver = "docker"

      config {
        image = "grafana/loki:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 200
        memory = 256
      }

      service {
        name = "loki"
        port = "http"

        check {
          type     = "http"
          path     = "/ready"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}