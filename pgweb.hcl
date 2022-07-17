## View Pgweb - http://pgweb.service.consul:8081

job "pgweb" {
  datacenters = ["dc1"]

  group "pgweb" {
    network {
      port "pgweb" {
        to = "8081"
        static = "8081"
      }
    }
    task "server" {
      driver = "docker"

      config {
        image = "sosedoff/pgweb"
        ports = ["pgweb"]
      }

      env {
        ## URL Schema -  postgres://user:password@host:port/database?sslmode=[mode]
        DATABASE_URL= "postgres://postgres:postgres@postgres.service.consul:5432/postgres?sslmode=disable"
      }

      service {
        name = "pgweb"
        tags = ["database access"]
        port = "pgweb"
      }
    }
  }
}
