provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "azurerm_client_config" "current" {}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags             = merge(var.tags, local.module_tag)
  
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id

}

terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}