job "reverse-proxy-master" {
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${node.class}"
    operator  = "="
    value     = "proxy-only"
  }

  group "reverse-proxy-master" {
    count = 1

    network {
      mode = "host"
    }

    task "reverse-proxy-master" {
      driver = "podman"

      config {
        image = "ghcr.io/berkaydedeoglu/reverse-proxy-master:latest"
        network_mode  = "host"
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          port "http" {
            static = 80
          }
          port "https" {
            static = 443
          }
        }
      }
    }
  }
}
