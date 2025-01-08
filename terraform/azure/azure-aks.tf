resource "azurerm_kubernetes_cluster" "aks-prod-starboardsocial" {
  name                = "aks-prod-starboardsocial"
  location            = azurerm_resource_group.rg-prod-starboardsocial.location
  resource_group_name = azurerm_resource_group.rg-prod-starboardsocial.name
  dns_prefix          = "aks-prod-starboardsocial"
  sku_tier = "Free"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    auto_scaling_enabled = false
    temporary_name_for_rotation = "temp"
    node_public_ip_enabled = false
  }
    network_profile {
      network_plugin = "none"
      outbound_type = "loadBalancer"
      load_balancer_sku = "standard"
      load_balancer_profile {
        outbound_ip_address_ids = [ azurerm_public_ip.ip-aks-prod-starboardsocial.id ]
      }
    }

  depends_on = [ 
    azurerm_resource_group.rg-prod-starboardsocial, 
    azurerm_public_ip.ip-aks-prod-starboardsocial
    ]
}

resource "azurerm_public_ip" "ip-aks-prod-starboardsocial" {
  name                = "ip-aks-prod-starboardsocial"
  location            = azurerm_resource_group.rg-prod-starboardsocial.location
  resource_group_name = azurerm_resource_group.rg-prod-starboardsocial.name
  allocation_method   = "Static"
  domain_name_label   = "aks-prod-starboardsocial"
  tags = {
    "k8s-azure-cluster-name" = "kubernetes"
    "k8s-azure-service" = "prod-starboardsocial/kong-gateway-proxy"
  }
}