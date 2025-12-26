resource "azurerm_resource_group" "this" {
  name     = "rg-wasigo-dev"
  location = var.location

  tags = {
    project     = var.project
    environment = var.environment
  }
}

resource "azurerm_container_registry" "this" {
  name                = "wasigodevacr"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku           = "Basic"
  admin_enabled = false

  tags = {
    project     = var.project
    environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-wasigo-dev"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "wasigo-dev"

  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 32
    type            = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    project     = var.project
    environment = var.environment
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
