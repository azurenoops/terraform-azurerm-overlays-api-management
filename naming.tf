# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
#------------------------------------------------------------
data "azurenoopsutils_resource_name" "apim" {
  name          = var.workload_name
  resource_type = "azurerm_api_management"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.environment, local.name_suffix, var.use_naming ? "" : "apim"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "keyvault" {
  name          = var.workload_name
  resource_type = "azurerm_key_vault"
  prefixes      = [var.org_name, module.mod_azregions.location_short]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.environment, local.name_suffix, var.use_naming ? "" : "kv"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}