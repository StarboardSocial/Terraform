provider "kubernetes" {
  config_path    = "kubeconfig"
  config_context = "aks-prod-starboardsocial"
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig"
  }
}


resource "kubernetes_namespace" "k8-ns-prod-starboardsocial" {
  metadata {
    name = "prod-starboardsocial"
  }
  depends_on = [var.depends_on_azure_k8]
}

variable "depends_on_azure_k8" {
  type    = any
  default = []
}


variable "external_ip" {
  type    = any
  default = ""
}