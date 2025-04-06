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

    # network bloğu artık gereksiz, host network kullandığımız için kaldırıyoruz
    task "fastapi-nomad-deployer" {
      driver = "podman"

      config {
        image         = "ghcr.io/berkaydedeoglu/nomad-deployer:latest"
        network_mode  = "host"  # 🔥 Kritik ayar
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
        port = "http"  # Bu hala gerekli çünkü Consul servisini register ederken kullanılıyor

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
