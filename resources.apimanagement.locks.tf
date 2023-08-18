# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Resource Group Lock configuration - Remove if not needed 
#------------------------------------------------------------
resource "azurerm_management_lock" "apim_lock" {
  depends_on = [
    azurerm_api_management.api_management
  ]
  count = var.enable_resource_locks ? 1 : 0

  name       = "${local.apim_name}-${var.lock_level}-lock"
  scope      = azurerm_api_management.api_management.id
  lock_level = var.lock_level
  notes      = "API Management '${local.apim_name}' is locked with '${var.lock_level}' level."
}

resource "azurerm_management_lock" "apim_identity_lock" {
  depends_on = [
    azurerm_api_management.api_management
  ]
  count = var.enable_resource_locks ? 1 : 0

  name       = "${local.apim_user_assigned_identity_name}-${var.lock_level}-lock"
  scope      = data.azurerm_user_assigned_identity.apim_identity.id
  lock_level = var.lock_level
  notes      = "API Management Identity '${local.apim_user_assigned_identity_name}' is locked with '${var.lock_level}' level."
}

resource "azurerm_management_lock" "apim_nsg_level_lock" {
  depends_on = [
    azurerm_api_management.api_management
  ]
  count = var.enable_resource_locks ? 1 : 0

  name       = "${local.apim_nsg_name}-${var.lock_level}-lock"
  scope      = data.azurerm_network_security_group.apim-nsg.id
  lock_level = var.lock_level
  notes      = "API Management NSG '${local.apim_nsg_name}' is locked with '${var.lock_level}' level."
}

resource "azurerm_management_lock" "apim_pip_level_lock" {
  depends_on = [
    azurerm_api_management.api_management
  ]
  count = var.enable_resource_locks && var.environment == "public" ? 1 : 0

  name       = "${local.apim_pip_name}-${var.lock_level}-lock"
  scope      = azurerm_public_ip.apim_pip[0].id
  lock_level = var.lock_level
  notes      = "API Management PIP '${local.apim_pip_name}' is locked with '${var.lock_level}' level."
}

resource "azurerm_management_lock" "apim_level_lock" {
  depends_on = [
    azurerm_api_management.api_management
  ]
  count = var.enable_resource_locks ? 1 : 0

  name       = "${local.apim_name}-${var.lock_level}-lock"
  scope      = azurerm_api_management.api_management.id
  lock_level = var.lock_level
  notes      = "API Management '${local.apim_name}' is locked with '${var.lock_level}' level."
}
