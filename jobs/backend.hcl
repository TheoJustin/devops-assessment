job "hubspot-backend" {
  datacenters = ["dc1"]
  type        = "service"

  group "api" {
    count = 1

    network {
      port "http" {
        static = 5000
        to = 5104
      }
    }

    task "server" {
      driver = "docker"
      
      env {
        DATABASE_URL = "sqlite:///local_staging.db" 
      }
      
      config {
        image      = "theojustin/hubspot-app:staging"  # <- pulls from registry
        force_pull = true                                          # <- always get latest
        ports      = ["http"]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      service {
        name = "hubspot-api"
        port = "http"

        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}



