terraform {
  backend "azurerm" {
    container_name = "tfstate"
    key            = "demo-aks.tfstate"
  }
}
