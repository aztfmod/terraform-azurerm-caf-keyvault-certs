provider "azurerm" {
  version = "2.14.0"
  features {
     key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

 

provider "azurecaf" {

}

data "azurerm_client_config" "current" {}

resource "azurecaf_naming_convention" "rg_test" {
  name          = local.resource_groups.test.name
  prefix        = local.prefix != "" ? local.prefix : null
  postfix       = local.postfix != "" ? local.postfix : null
  max_length    = local.max_length != "" ? local.max_length : null
  resource_type = "azurerm_resource_group"
  convention    = local.convention
}

resource "azurerm_resource_group" "rg_test" {
  name     = azurecaf_naming_convention.rg_test.result
  location = local.resource_groups.test.location
  tags     = local.tags
}


module "la_test" {
  source  = "aztfmod/caf-log-analytics/azurerm"
  version = "2.1.0"

  convention          = local.convention
  location            = local.location
  name                = local.name_la
  solution_plan_map   = local.solution_plan_map
  prefix              = local.prefix
  resource_group_name = azurerm_resource_group.rg_test.name
  tags                = local.tags
}

module "diags_test" {
  source  = "aztfmod/caf-diagnostics-logging/azurerm"
  version = "2.0.1"

  name                = local.name_diags
  convention          = local.convention
  resource_group_name = azurerm_resource_group.rg_test.name
  prefix              = local.prefix
  location            = local.location
  tags                = local.tags
  enable_event_hub    = local.enable_event_hub
}

module "akv_test" {
  source  = "aztfmod/caf-keyvault/azurerm"
  version = "2.0.2"

  convention              = local.convention
  akv_config              = local.akv_config
  resource_group_name     = azurerm_resource_group.rg_test.name
  location                = local.location
  tags                    = local.tags
  log_analytics_workspace = module.la_test
  diagnostics_map         = module.diags_test.diagnostics_map
  diagnostics_settings    = local.akv_config.diagnostics_settings
  purge_protection_enabled = false


}

# AKV policies 
resource "azurerm_key_vault_access_policy" "developer" {
  key_vault_id = module.akv_test.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = []

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  certificate_permissions = [
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "setissuers",
    "update",
  ]
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

module "domain" {
  source = "github.com/aztfmod/terraform-azurerm-caf-domain"

  prefix              = local.prefix
  resource_group_name = azurerm_resource_group.rg_test.name
  tags                = local.tags
  name                = local.domain #format("%s.com", random_string.random.result)
  location            = local.location
  contract            = local.contract
  lock_zone           = local.lock_zone
  lock_domain         = local.lock_domain
}

module "domain_cert" {
  source = "../.."

  keyvault_id = module.akv_test.id

  certificate = local.certificate

  domain_resource_group_name = azurerm_resource_group.rg_test.name
  tags                       = local.tags
  # log_analytics_workspace  = module.la_test
  # diagnostics_map          = module.diags_test.diagnostics_map
  # diagnostics_settings     = local.akv_config.diagnostics_settings
}