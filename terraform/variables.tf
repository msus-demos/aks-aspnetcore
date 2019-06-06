// Naming
variable "name" {
  type        = "string"
  description = "Location of the azure resource group."
  default     = "demo-aks"
}

variable "environment" {
  type        = "string"
  description = "Name of the deployment environment"
  default     = "dev"
}

// Resource information

variable "location" {
  type        = "string"
  description = "Location of the azure resource group."
  default     = "WestUS2"
}

variable tags {
  type        = "map"
  description = "Tags to apply on all groups and resources."

  default = {
    mtc-architect = "Joey Lorich"
    deployed-with = "Terraform"
  }
}

// Node type information

variable "linux_node_count" {
  type        = "string"
  description = "The number of K8S nodes to provision."
  default     = 3
}

variable "windows_node_count" {
  type        = "string"
  description = "The number of K8S nodes to provision."
  default     = 3
}


variable "linux_node_sku" {
  type        = "string"
  description = "The size of each node."
  default     = "Standard_D1_v2"
}

variable "windows_node_sku" {
  type        = "string"
  description = "The size of each node."
  default     = "Standard_D1_v2"
}

variable "dns_prefix" {
  type        = "string"
  description = "DNS Prefix"
  default     = "msus-demo-aks"
}

// Network information

variable "vnet_address_space" {
  type        = "string"
  description = "Address space for the vnet"
  default     = "10.0.0.0/8"
}

variable "vnet_pod_subnet_space" {
  type        = "string"
  description = "Address space for the pod subnet"
  default     = "10.1.0.0/16"
}

variable "vnet_ingress_subnet_space" {
  type        = "string"
  description = "Address space for the gateway subnet"
  default     = "10.2.0.0/24"
}

variable "vnet_gateway_subnet_space" {
  type        = "string"
  description = "Address space for the gateway subnet"
  default     = "10.2.1.0/24"
}

variable "ingress_load_balancer_ip" {
  type        = "string"
  description = "Address for the ingress controller load balancer"
  default     = "10.2.0.10"
}

variable "gateway_instance_count" {
  type        = "string"
  description = "The amount of App Gateway instances to run"
  default     = "1"
}
