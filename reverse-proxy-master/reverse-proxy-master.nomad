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

    task "reverse-proxy-master" {
      driver = "podman"

      config {
        image         = "ghcr.io/berkaydedeoglu/reverse-proxy-master:latest"
        force_pull = true
        network_mode  = "host"
        user = "0" 
        volumes = [
          "/opt/caddy_data:/data:Z",
          "/opt/caddy_config:/config:Z"
        ]
      }

      resources {
        cpu    = 200
        memory = 128
      }

      service {
        name = "caddy-reverse"

        check {
          name         = "http health"
          type         = "http"
          path         = "/_health"
          interval     = "10s"
          timeout      = "2s"
          port         = 80
          address_mode = "driver"
        }
      }

      logs {
        max_files     = 3
        max_file_size = 10
      }
    }
  }
}
