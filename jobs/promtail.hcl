# Promtail job definition for Nomad

job "promtail" {
  datacenters = ["dc1"]
  type        = "system"

  group "agents" {
    network {
      port "http" {
        static = 9080
      }
    }

    task "promtail" {
      driver = "docker"

      config {
        image = "grafana/promtail:latest"
        ports = ["http"]
        
        args = [
          "-config.file=/local/promtail.yaml"
        ]

        # This is the magic! It mounts the Docker socket so Promtail can read the logs of all other containers
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock",
          "/var/lib/docker/containers:/var/lib/docker/containers:ro"
        ]
      }

      # Dynamically generate the Promtail config
      template {
        destination = "local/promtail.yaml"
        data = <<EOH
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  # Ship the logs to the Loki container via your Mac's localhost bridge
  - url: http://host.docker.internal:3100/loki/api/v1/push

scrape_configs:
  # Automatically discover and scrape ALL Docker containers
  - job_name: docker
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container'
EOH
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}