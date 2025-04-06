job "nomad-deployer" {
  datacenters = ["dc1"]
  type = "service"

  group "deployer" {
    count = 1

    network {
      port "http" {
        static = 8000
      }
    }

    task "fastapi-nomad-deployer" {
      driver = "docker"

      config {
        image = "ghcr.io/berkaydedeoglu/nomad-deployer:latest"
        ports = ["http"]
      }

      env {
        GITHUB_REPO_URI   = "${NOMAD_SECRETS_GITHUB_REPO_URI}"
        GITHUB_BRANCH     = "${NOMAD_SECRETS_GITHUB_BRANCH}"
        NOMAD_ADDR        = "${NOMAD_SECRETS_NOMAD_ADDR}"
        NOMAD_ACL_TOKEN   = "${NOMAD_SECRETS_NOMAD_ACL_TOKEN}"
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
