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
        destination = "local/env.sh"
        perms = "0755"
        data = <<-EOF
          #!/bin/bash
          export GITHUB_REPO_URI="${NOMAD_VAR_GITHUB_REPO_URI}"
          export GITHUB_BRANCH="${NOMAD_VAR_GITHUB_BRANCH}"
          export NOMAD_ADDR="${NOMAD_VAR_NOMAD_ADDR}"
          export NOMAD_ACL_TOKEN="${NOMAD_VAR_NOMAD_ACL_TOKEN}"
          exec "$@"
          EOF
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
