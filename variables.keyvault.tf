
##########################
# KeyVault Configuration #
##########################
variable "enable_key_vault" {
  description = "Controls if the keyvault should be created. Default is true."
  type        = bool
  default     = true
}
variable "key_vault_custom_name" {
  description = "Custom name for the keyvault. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}
variable "purge_protection_enabled" {
  description = "Specifies whether protection against purge is enabled for this key vault. Default is true."
  type        = bool
  default     = true
}

variable "enabled_for_template_deployment" {
  description = "Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = bool
  default     = false
}

variable "key_vault_sku_name" {
  description = "The SKU name of the Key Vault to create. Possible values are standard and premium."
  type        = string
  default     = "standard"
}

variable "enable_application_insights" {
  description = "Controls if the application insights should be created. Default is true."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to use for Application Insights."
  type        = string
  default     = null
}
