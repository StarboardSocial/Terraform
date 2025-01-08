terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.14.0"
    }
    local = {
      source  = "hashicorp/local"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}


module "azure" {
  source = "./azure"
}



module "kubernetes" {
  source = "./kubernetes"
  
  depends_on_azure_k8 = module.azure.ref-k8
  external_ip = module.azure.external-ip
}