locals {
  path = abspath(".")
}

job "postgres" {
  datacenters = ["dc1"]
  type = "service"

  group "postgres" {
    count = 1

    network {
      port "db" {
        to = "5432"
        static = "5432"
      }
    }

    volume "postgres" {
      type      = "host"
      read_only = false
      source    = "database"
    }

    task "postgres" {
      driver = "docker"

      volume_mount {
        volume      = "postgres"
        destination = "/docker-entrypoint-initdb.d"
        read_only   = false
      }

      config {
        image = "postgres"
        ports = ["db"]
      }

      env {
          POSTGRES_USER="postgres"
          POSTGRES_PASSWORD="postgres"
          POSTGRES_DB="postgres"
      }

  
      // logs {
      //   max_files     = 5
      //   max_file_size = 15
      // }

      // resources {
      //   cpu = 1000
      //   memory = 1024
      // }
      service {
        name = "postgres"
        tags = ["postgres for backstage"]
        port = "db"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
    // restart {
    //   attempts = 10
    //   interval = "5m"
    //   delay = "25s"
    //   mode = "delay"
    // }

  }

  update {
    max_parallel = 1
    min_healthy_time = "5s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }
}