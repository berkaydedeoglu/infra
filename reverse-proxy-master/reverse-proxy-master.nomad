job "reverse-proxy-master" {
  datacenters = ["dc1"]
  type = "service"

  group "reverse-proxy-master" {
    count = 1

    network {
      mode = "host"
    }

    task "reverse-proxy-master" {
      driver = "podman"

      config {
        image = "ghcr.io/berkaydedeoglu/reverse-proxy-master:latest"
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}
