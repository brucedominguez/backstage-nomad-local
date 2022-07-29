locals {
  image = "brucedominguez/backstage-nomad-example:1.0.0"
  github_token = "<ADD PERSONAL ACCESS TOKEN HERE>"
  cataglog_info_url = "https://github.com/<YOUR ORG>/backstage-nomad-local/blob/main/catalog/all.yaml"
}

job "backstage" {
  datacenters = ["dc1"]

  group "backstage" {
    network {
      port "backend" {
        to = "7007"
        static = "7007"
      }
      port "app" {
        to = 3000
        static = 3000
      }
    }
    task "server" {
      driver = "docker"

      config {
        image = "${local.image}"
        ports = ["app", "backend"]
      }

      env {
          POSTGRES_HOST = "postgres.service.consul"
          POSTGRES_PORT = "5432"
          POSTGRES_USER = "postgres"
          POSTGRES_PASSWORD = "postgres"
          GITHUB_TOKEN = "${local.github_token}"
          GITHUB_CATALOG_URL = "${local.cataglog_info_url}"
      }

      service {
        name = "backstage"
        tags = ["backstage"]
        port = "backend"
      }
    }
  }
}
