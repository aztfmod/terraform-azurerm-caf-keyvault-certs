variable "prefix" {
  
}

variable "tags" {
    description = "(Required) map of tags for the deployment"
}

variable "location" {
    description = "(Required) Resource Location"
}

variable "resource_group_name" {
    description = "(Required) Resource group of the App Insights"
}

variable "domain_resource_group_name" {
  
}

variable "convention" {
  
}

variable "akv_config" {
    description = "(Required) Key Vault Configuration Object"
}


variable "email" {
  
}

variable "certificates" {
    description = "(Required) list of domain hostnames to generate certificates for"
}
