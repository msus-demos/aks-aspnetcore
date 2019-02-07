// Naming
variable "name" {
  type        = "string"
  description = "Location of the azure resource group."
  default     = "demo-aks"
}

variable "environment" {
  type        = "string"
  description = "Name of the deployment environment"
  default     = "sandbox"
}

// Service Principal
variable "client_id" {
  type        = "string"
  description = "Service Principal Client ID"
}

variable "client_secret" {
  type        = "string"
  description = "Service Principal Client Secret"
}

// Resource information

variable "location" {
  type        = "string"
  description = "Location of the azure resource group."
  default     = "WestUS2"
}

variable tags {
  type        = "map"
  description = "Tags to apply to this resource and group"
  default     = {}
}

// Node type information

variable "node_count" {
  type        = "string"
  description = "The number of K8S nodes to provision."
  default     = 3
}

variable "node_type" {
  type        = "string"
  description = "The size of each node."
  default     = "Standard_D1_v2"
}

variable "node_os" {
  type        = "string"
  description = "Windows or Linux"
  default     = "Linux"
}

variable "dns_prefix" {
  type        = "string"
  description = "DNS Prefix"
  default     = "mtcden"
}
