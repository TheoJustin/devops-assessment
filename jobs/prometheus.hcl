# Prometheus job definition for Nomad

job "prometheus" {
  datacenters = ["dc1"]
  type        = "service"

  group "monitoring" {
    count = 1

    network {
      port "http" {
        static = 9090
      }
    }

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:latest"
        ports = ["http"]
        
        # Tell Prometheus to use the config file we generate below
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/prometheus"
        ]
      }

      # This template block dynamically creates prometheus.yml inside the container!
      template {
        destination = "local/prometheus.yml"
        data = <<EOH
global:
  scrape_interval: 10s
  evaluation_interval: 10s

scrape_configs:
  # Scrape Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Magic: Automatically find ANY service registered in Consul!
  - job_name: 'consul-services'
    consul_sd_configs:
      # host.docker.internal allows the Docker container to reach your Mac's localhost where Consul is running
      - server: 'host.docker.internal:8500' 
    
    # This relabeling rule takes the service name from Consul and makes it a readable label in Prometheus
    relabel_configs:
      - source_labels: [__meta_consul_service]
        target_label: service
EOH
      }

      resources {
        cpu    = 200
        memory = 256
      }

      service {
        name = "prometheus"
        port = "http"
        
        check {
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}