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