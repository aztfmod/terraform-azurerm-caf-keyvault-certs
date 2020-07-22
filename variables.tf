variable "tags" {
  description = "(Required) map of tags for the deployment"
}

variable "domain_resource_group_name" {
  description = "(Required) Name of resource group for the certificate"
}

variable "keyvault_id" {
  description = "(Required) Resource ID of the Azure Key Vault"
}

variable "certificate" {
    description = "(Required) certificate object"
}

