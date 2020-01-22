provider "kubernetes" {
  config_path   = "${local_file.kubernetes_config.filename}"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "1-namespace"
  }
}
