# The datacenter where this agent resides.
datacenter = "dc1"

# Directory where Consul stores state data locally.
# /tmp is used here for an ephemeral local setup.
data_dir = "/tmp/consul"

# Configures this single agent to act as a Server.
server = true

# The address the agent listens on for client communication.
# 0.0.0.0 binds to all available network interfaces.
client_addr = "0.0.0.0"

# Forces Consul to elect itself as the leader immediately.
# ONLY use this in a single-server setup like this one.
bootstrap_expect = 1

# Enables the web UI.
ui = true

# Sets the logging detail.
log_level = "INFO"