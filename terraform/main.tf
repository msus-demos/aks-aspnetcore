resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg"
  location = "${var.location}"

  tags = "${var.tags}"
}

resource "azurerm_application_insights" "default" {
  name                = "${var.name}-ai"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  application_type    = "Web"

  tags = "${var.tags}"
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "${var.name}-law"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = "${var.tags}"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${var.name}"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  dns_prefix          = "${var.dns_prefix}-${var.name}-aks-${var.environment}"

  agent_pool_profile {
    name            = "default"
    count           = "${var.node_count}"
    vm_size         = "${var.node_type}"
    os_type         = "${var.node_os}"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${azurerm_log_analytics_workspace.default.id}"
    }
  }

  tags = "${var.tags}"
}
