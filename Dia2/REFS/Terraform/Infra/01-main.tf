resource "digitalocean_kubernetes_cluster" "devops" { 
 name = "devops"
 region = "nyc1"
 version = "1.16.2-do.3"

 node_pool { 
  name = "devops-nodes"
  size = "s-1vcpu-2gb"
  node_count = 2
  }
}
