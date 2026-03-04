# datacenter = "dc1"
# data_dir = "/tmp/nomad"
# server {
#     enabled = true
#     bootstrap_expect = 1
# }
# client {
#     enabled = true
#     # for mac
#     network_interface = "lo0"
# }
# consul {
#     address = "127.0.0.1:8500"
# }

plugin "docker" {
  config {
    volumes {
      enabled = true
    }
  }
}