# The datacenter where this agent resides.
datacenter = "dc1"

# Directory where Nomad stores state and container data.
data_dir = "/tmp/nomad"

# Enables the server (control plane) functionality.
server {
  enabled          = true
  bootstrap_expect = 1
}

# Enables the client (worker node) functionality.
client {
  enabled = true
}

# Configures the integration with Consul.
# This points Nomad to the local Consul instance for service registration.
consul {
  address = "127.0.0.1:8500"
}