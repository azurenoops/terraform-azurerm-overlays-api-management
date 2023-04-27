# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "vnet" { 
depends_on = [
    module.mod_scaffold_rg]
  name                = var.virtual_network_name
  resource_group_name = local.resource_group_name
}
data "azurerm_subnet" "apim_subnet" {
depends_on = [
    module.mod_scaffold_rg]
  name                 = var.apim_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = local.resource_group_name
}

data "azurerm_subnet" "pe_subnet" {
depends_on = [
    module.mod_scaffold_rg]
  name                 = var.private_endpoint_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = local.resource_group_name
}

data "azurerm_redis_cache" "redis_cache" {
  depends_on = [
    module.mod_scaffold_rg,
    module.mod_redis_cache
  ]
  name                = module.mod_redis_cache.0.redis_name
  resource_group_name = local.resource_group_name
}
data "azurerm_resource_group" "rg" {
depends_on = [
    module.mod_scaffold_rg]
  name = local.resource_group_name
}
data "azurerm_key_vault" "apim_key_vault" {
depends_on = [
    module.mod_scaffold_rg,
    module.mod_key_vault]
  name                = module.mod_key_vault.0.key_vault_name
  resource_group_name = local.resource_group_name
}
data "azurerm_api_management" "apim" { 
depends_on = [
    azurerm_api_management.api_management]
  name                = local.apim_name
  resource_group_name = local.resource_group_name
}

