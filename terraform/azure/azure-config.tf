provider "azurerm" {
    subscription_id = "cb1db3f2-2e48-4a9a-932a-f3c255aa03b8"
  features {}
}

resource "azurerm_resource_group" "rg-prod-starboardsocial" {
  name     = "rg-prod-starboardsocial"
  location = "West Europe"
}


resource "local_file" "kubeconfig" {
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.aks-prod-starboardsocial.kube_config_raw

}

output "ref-k8" {
  value = {}
  depends_on = [azurerm_kubernetes_cluster.aks-prod-starboardsocial]
}

output "external-ip" {
  value = azurerm_public_ip.ip-aks-prod-starboardsocial.ip_address
}
