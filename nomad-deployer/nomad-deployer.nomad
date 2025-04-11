job "nomad-deployer" {
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${node.class}"
    operator  = "!="
    value     = "proxy-only"
  }

  group "deployer" {
    count = 1

    network {
      port "http" {
        static = 8000
      }
    }

    task "fastapi-nomad-deployer" {
      template {
        destination = "local/"
        perms  = "0755"
        source = "https://raw.githubusercontent.com/berkaydedeoglu/infra/refs/heads/main/nomad-deployer/env.sh"
      }

      driver = "podman"

      config {
        image         = "ghcr.io/berkaydedeoglu/nomad-deployer:latest"
        network_mode  = "host"
        force_pull    = true
        command      = "/local/env.sh"
      }

      resources {
        cpu    = 100
        memory = 80
      }

      service {
        name = "nomad-deployer"
        port = "http"

        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
