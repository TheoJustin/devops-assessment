# Grafana job definition for Nomad

job "grafana" {
  datacenters = ["dc1"]
  type        = "service"

  group "observability" {
    count = 1

    network {
      port "http" {
        static = 3000
        to     = 3000
      }
    }

    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 200
        memory = 256
      }

      service {
        name = "grafana"
        port = "http"

        check {
          type     = "http"
          path     = "/api/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}