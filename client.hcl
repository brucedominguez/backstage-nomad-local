bind_addr = "0.0.0.0"                                                                  
server {                                                                                                                         
  enabled = true                                                                       
  bootstrap_expect = 1                                                                                                    
} 

client {
  enabled = true
  servers = ["127.0.0.1"]

  host_volume "database" {
    path      = "/Add Absolute Path Here/backstage-nomad/data"
    read_only = false
  }
}
                                                                               
plugin "docker" {                                                                      
    volumes {
        enabled = true
    }                                                                                
}