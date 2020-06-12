variable "prefix" {
  description = "(Optional) You can use a prefix to the name of the resource"
  type        = string
  default = ""
}

variable "postfix" {
  description = "(Optional) You can use a postfix to the name of the resource"
  type        = string
  default = ""
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

variable "diagnostics_map" {
  description = "(Required) Storage account and Event Hub for AKV"  
}

variable "log_analytics_workspace" {
  description = "(Required) Log Analytics workspace for AKV"
}

variable "diagnostics_settings" {
 description = "(Required) Map with the diagnostics settings for AKV"
}