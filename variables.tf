# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


###########################
# Global Configuration   ##
###########################

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environment"
  type        = string
}

variable "workload_name" {
  description = "Name of the workload_name"
  type        = string
}

variable "org_name" {
  description = "Name of the organization"
  type        = string
}



#######################
# RG Configuration   ##
#######################

variable "create_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false."
  type        = bool
  default     = false
}

variable "use_location_short_name" {
  description = "Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored."
  type        = bool
  default     = true
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}
#####################################
# API Management Configuration     ##
#####################################

variable "create_apim_keyvault" {
  description = "Controls if the keyvault should be created. If set to false, the keyvault name must be provided. Default is false."
  type        = bool
  default     = true
}

variable "create_apim_redis_cache" {
  description = "Controls if the redis cache should be created. If set to false, the redis cache name must be provided. Default is false."
  type        = bool
  default     = true
}

variable "enable_redis_cache"{ 
  description = "Controls if the redis cache should be enabled."
  type        = bool
  default     = true
}

variable "apim_custom_name" {
  description = "Custom name for the API Management instance. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "sku_tier"{
  description = "The tier of the API Management instance. Possible values are Developer, Basic, Standard, Premium, Consumption."
  type        = string
  default     = "Developer"
}
variable "sku_capacity"{
  description = "The capacity of the API Management instance. Possible values are positive integers from 1-12, except for Consumption tier where it is 0."
  type        = number
  default     = 1
}
variable virtual_network_type {
  description = "The type of the virtual network. Possible values are External, Internal, None."
  type        = string
  default     = "Internal"
}

variable "publisher_email" {
  description = "The email address of the publisher."
  type        = string
}
variable "publisher_name" {
  description = "The name of the publisher."
  type        = string
}

variable "enable_user_identity" {
  description = "Controls if the user identity should be enabled."
  type        = bool
  default     = true
}

variable "min_api_version" {
  description = "The minimum supported API version for the API Management Management API."
  type        = string
  default     = "2022-08-01"
}
#####################################
# Networking Configuration         ## 
#####################################
variable "apim_subnet_name" {
  description = "Name of the subnet for the API Management"
  type        = string
}
variable "private_endpoint_subnet_prefix" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default = []
}
variable "private_endpoint_subnet_name" {
  description = "Name of the subnet for the private endpoint"
  type        = string
}
variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}
variable "existing_subnet_id" {
  description = "The ID of an existing subnet to use. If not set, a new subnet will be created."
  type        = string
  default     = null
}
variable "existing_apim_private_dns_zone" {
  description = "The ID of an existing private dns zone to use. If not set, a new private dns zone will be created."
  type        = string
  default     = null
}
variable "existing_apim_dev_portal_dns_zone" {
  description = "The ID of an existing private dns zone to use. If not set, a new private dns zone will be created."
  type        = string
  default     = null
}
variable "existing_vnet_id"{
  description = "The ID of an existing virtual network to use. If not set, a new virtual network will be created."
  type        = string
  default     = null
}
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
