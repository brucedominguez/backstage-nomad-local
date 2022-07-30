bind_addr = "0.0.0.0"                                                                  
server {                                                                                                                         
  enabled = true                                                                       
  bootstrap_expect = 1                                                                                                    
} 

client {
  enabled = true
  servers = ["127.0.0.1"]

  host_volume "database" {
    path      = "/ADD PATH HERE TO YOUR GIT REPO/backstage-nomad/data"
    read_only = false
  }
}
                                                                               
plugin "docker" {                                                                      
    volumes {
        enabled = true
    }                                                                                
}