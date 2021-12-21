resource "libvirt_network" "test_debian" {  
  name = "test_debian"  
  mode = "nat"  
  domain = "test.local"  
  addresses = ["10.17.3.0/24"]  
  dns {    
    enabled = true    
    local_only = true    
  }
}