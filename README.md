[![VScodespaces](https://img.shields.io/endpoint?url=https%3A%2F%2Faka.ms%2Fvso-badge)](https://online.visualstudio.com/environments/new?name=terraform-azurerm-caf-caf-keyvault-certs&repo=aztfmod/terraform-azurerm-caf-caf-keyvault-certs)

# Create SSL certs and insert them into Azure Key Vault

Using Let's Encrypt for now.

Supported features:

1. AKV name is generated randomly based on (prefix+name)+randomly generated string to ensure WW uniqueness (created on 24 chars, which is max name length of AKV name)
2. AKV main settings: enabled for deployment, disk encryption, template deployment
3. AKV SKU: Premium or Standard
4. AKV networks ACL

Non-supported features:

1. Support for AKV policies is kept outside of this module in order to preserve consistency of policies. Ie: for each AKV creation, you should set your access policy tailored to the specific purpose (see AKV sample policy file - access_policy_sample.tf)

Reference the module to a specific version (recommended):

```hcl
module "keyvault_certs" {
  source                     = "../../modules/terraform-azurerm-caf-keyvault-certs"
  prefix                     = var.prefix
  resource_group_name        = var.resource_group_name
  domain_resource_group_name = var.domain_resource_group_name
  location                   = var.location
  convention                 = var.convention
  akv_id                     = var.akv_id

  tags  = var.tags
  email = var.email

  certificates = local.certificates
}
```

## Inputs

| Name | Type | Default | Description |
| -- | -- | -- | -- |
| certificates | list | None | (Required) list of domain hostnames to generate certificates for. |
| email | string | None | (Required) email for certs registration. |
| resource_group_name | string | None | (Required) Name of the resource group where to create the resource. Changing this forces a new resource to be created. |
| location | string | None | (Required) Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created.  |
| tags | map | None | (Required) Map of tags for the deployment.  |
| log_analytics_workspace | string | None | (Required) Log Analytics Workspace. |
| diagnostics_map | map | None | (Required) Map with the diagnostics repository information.  |
| diagnostics_settings | object | None | (Required) Map with the diagnostics settings. See the required structure in the following example or in the diagnostics module documentation. |
| akv_config | object | None | (Required) Key Vault Configuration Object as described in the Parameters section. |
| convention | string | None | (Required) Naming convention to be used (check at the naming convention module for possible values).  |
| prefix | string | None | (Optional) Prefix to be used. |

## Parameters

### certificates

(Required) list of domain hostnames to generate certificates for. 
```hcl
variable "certificates" {
  description = "(Required) list of domain hostnames to generate certificates for"
}
```
Sample:
```hcl
certificates = ["helloworld.domain.com", "*.domain.com"]
```


### akv_config

(Required) Key Vault Configuration Object"

```hcl
variable "akv_config" {
  description = "(Required) Key Vault Configuration Object"
}
```

Sample:

```hcl
akv_config = {
    name       = "myakv"

    akv_features = {
        enabled_for_disk_encryption = true
        enabled_for_deployment      = false
        enabled_for_template_deployment = true
        soft_delete_enabled = true
        purge_protection_enabled = true
    }
    #akv_features is optional

    sku_name = "premium"
    network_acls = {
         bypass = "AzureServices"
         default_action = "Deny"
    }
    #network_acls is optional
}
```


## log_analytics_workspace

(Required) Log Analytics workspace for AKV

```hcl
variable "log_analytics_workspace" {
  description = "(Required) Log Analytics workspace for AKV"
}
```

Example

```hcl
log_analytics_workspace = module.loganalytics.object
```

## diagnostics_map

(Required) Map with the diagnostics repository information"

```hcl
variable "diagnostics_map" {
 description = "(Required) Map with the diagnostics repository information"
}
```

Example

```hcl
  diagnostics_map = {
      diags_sa      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/arnaud-hub-operations/providers/Microsoft.Storage/storageAccounts/opslogskumowxv"
      eh_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/arnaud-hub-operations/providers/Microsoft.EventHub/namespaces/opslogskumowxv"
      eh_name       = "opslogskumowxv"
  }
```

### diagnostics_settings

(Required) Map with the diagnostics settings for AKV deployment.
See the required structure in the following example or in the diagnostics module documentation.

```hcl
variable "diagnostics_settings" {
 description = "(Required) Map with the diagnostics settings for AKV deployment"
}
```

Example

```hcl
diagnostics_settings = {
    log = [
                # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                ["AuditEvent", true, true, 60],
        ]
    metric = [
                #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                  ["AllMetrics", true, true, 60],
    ]
}
```


## Output

| Name | Type | Description | 
| -- | -- | -- | 
| principal_id | string | Returns the Managed Identity ID. |
| secret_ids | string | Returns the AKV secret IDs of the created certificates. | 
| identity_ids | list | Returns the Managed Identity ID to access the created AKV. |
