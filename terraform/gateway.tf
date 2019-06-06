locals {

  gateway_name                   = "${var.name}-${var.environment}-gateway"
  gateway_ip_name                = "${var.name}-${var.environment}-ip"
  gateway_ip_config_name         = "${var.name}-ipconfig"
  frontend_port_name             = "${var.name}-feport"
  frontend_ip_configuration_name = "${var.name}-feip"
  backend_address_pool_name      = "${var.name}-bepool"
  http_setting_name              = "${var.name}-http"
  probe_name                     = "${var.name}-probe"
  listener_name                  = "${var.name}-lstn"
  ssl_name                       = "${var.name}-ssl"
  url_path_map_name              = "${var.name}-urlpath"
  url_path_map_rule_name         = "${var.name}-urlrule"
  request_routing_rule_name      = "${var.name}-router"
}

# Public IP for our Application
resource "azurerm_public_ip" "ip" {
  name                = "${local.gateway_ip_name}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  location            = "${azurerm_resource_group.default.location}"
  domain_name_label   = "${local.gateway_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Application gateway to handle SSL Termination, WAF Integration, and routing to AKS Ingress
resource "azurerm_application_gateway" "gateway" {
  name                = "${local.gateway_name}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  location            = "${azurerm_resource_group.default.location}"

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = "${var.gateway_instance_count}"
  }

  gateway_ip_configuration {
    name      = "${local.gateway_ip_config_name}"
    subnet_id = "${azurerm_subnet.gateway.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}-http"
    port = 80
  }

  frontend_port {
    name = "${local.frontend_port_name}-https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.ip.id}"
  }

  backend_address_pool {
    name         = "${local.backend_address_pool_name}"
    ip_addresses = ["${var.ingress_load_balancer_ip}"]
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "http"
    request_timeout       = 1
    probe_name            = "${local.probe_name}"
    #host                  = "${var.ingress_load_balancer_ip}"
    #pick_host_name_from_backend_address = "true"
  }

  http_listener {
    name                           = "${local.listener_name}-http"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}-http"
    protocol                       = "http"
  }

  probe {
    name                = "${local.probe_name}"
    protocol            = "http"
    path                = "/nginx-health"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = "${var.ingress_load_balancer_ip}"
  }

  request_routing_rule {
    name                           = "${local.request_routing_rule_name}-http"
    rule_type                      = "PathBasedRouting"
    http_listener_name             = "${local.listener_name}-http"
    url_path_map_name              = "${local.url_path_map_name}"
  }

  url_path_map {
    name                               = "${local.url_path_map_name}"
    default_backend_address_pool_name  = "${local.backend_address_pool_name}"
    default_backend_http_settings_name = "${local.http_setting_name}"
    
    path_rule {
      name                       = "${local.url_path_map_rule_name}"
      backend_address_pool_name  = "${local.backend_address_pool_name}"
      backend_http_settings_name = "${local.http_setting_name}"
      paths = [
        "/*"
      ]
    }
  }
}