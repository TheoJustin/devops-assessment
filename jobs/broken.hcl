job "hubspot-broken" {
  datacenters = ["dc1"]
  type        = "service"

  group "api" {
    count = 1

    network {
      port "http" {
        static = 5005
        to     = 5104 
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "theojustin/hubspot-app:staging"
        ports = ["http"]
      }

      env {
        DATABASE_URL = "sqlite:///local_staging.db"
        ENVIRONMENT  = "staging"
        FLASK_ENV    = "staging"
      }

      resources {
        cpu    = 200
        memory = 256
      }

      service {
        name = "hubspot-broken"
        port = "http"

        check {
          type     = "http"
          path     = "/scan/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}