resource "digitalocean_kubernetes_cluster" "kdetony" {
  name    = "kskdetony"
  region  = "nyc1"
  version = "1.15.4-do.0"

  node_pool {
    name       = "kdetony-nodes"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}
