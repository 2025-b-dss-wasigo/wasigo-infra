resource "azurerm_resource_group" "this" {
  name     = "rg-wasigo-dev"
  location = "eastus"

  tags = {
    "project"     = "wasigo"
    "environment" = "dev"
  }
}

resource "azurerm_container_registry" "this" {
  name                = "wasigodevacr"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku           = "Basic"
  admin_enabled = false
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-wasigo-dev"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "wasigo-dev"

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity { type = "SystemAssigned" }

  tags = {
    "project"     = "wasigo"
    "environment" = "dev"
  }
}
