# **READ ME**

Thanks for your interest in Cloud Adoption Framework for Azure landing zones on Terraform.
This module is now deprecated and no longer maintained. 

As part of Cloud Adoption Framework landing zones for Terraform, we have migrated to a single module model, which you can find here: https://github.com/aztfmod/terraform-azurerm-caf and on the Terraform registry: https://registry.terraform.io/modules/aztfmod/caf/azurerm 

In Terraform 0.13 you can now call directly submodules easily with the following syntax:
```hcl
module "caf_firewall" {
  source  = "aztfmod/caf/azurerm//modules/networking/firewall"
  version = "0.4.18"
  # insert the 9 required variables here
}
```

[![VScodespaces](https://img.shields.io/endpoint?url=https%3A%2F%2Faka.ms%2Fvso-badge)](https://online.visualstudio.com/environments/new?name=terraform-azurerm-caf-caf-keyvault-certs&repo=aztfmod/terraform-azurerm-caf-caf-keyvault-certs)
[![Gitter](https://badges.gitter.im/aztfmod/community.svg)](https://gitter.im/aztfmod/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


# Create SSL certs and insert them into Azure Key Vault

Request a certificate and store it into Azure Key Vault.
Currently supported providers:
- [Let's Encrypt](https://letsencrypt.org/)


Reference the module to a specific version (recommended):

```hcl
module "keyvault_certs" {
  source  = "aztfmod/caf-virtual-keyvault-certs/azurerm"
  version = "0.x.y"

  keyvault_id                = module.akv_test.id
  certificate                = local.certificate
  domain_resource_group_name = azurerm_resource_group.rg_test.name
  tags                       = local.tags
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| acme | n/a |
| azurerm | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certificate | (Required) certificate object | `any` | n/a | yes |
| domain\_resource\_group\_name | (Required) Name of resource group for the certificate | `any` | n/a | yes |
| keyvault\_id | (Required) Resource ID of the Azure Key Vault | `any` | n/a | yes |
| tags | (Required) map of tags for the deployment | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| secret\_id | {for x in range(0,9) : x => x} |

<!--- END_TF_DOCS --->

### Parameters 

### contract 
(Required) Certificate details as per: 

  certificate = {
    common_name = local.domain
    email       = "joe@contoso.com"
    private_key = {
      algorithm = "RSA"
    }
  }
