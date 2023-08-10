# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Private Link for Apim - Default is "false" 
#---------------------------------------------------------

resource "azurerm_private_endpoint" "pep" {
  count               = var.enable_private_endpoint && var.existing_private_subnet_name != null ? 1 : 0
  name                = format("%s-private-endpoint", local.apim_name)
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = data.azurerm_subnet.snet.0.id
  tags                = merge({ "Name" = format("%s-private-endpoint", local.apim_name) }, var.add_tags, )

  private_service_connection {
    name                           = "apim-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_api_management.api_management.id
    subresource_names              = ["Gateway"]
  }
}

#------------------------------------------------------------------
# DNS zone & records for KV Private endpoints - Default is "false" 
#------------------------------------------------------------------
data "azurerm_private_endpoint_connection" "pip" {
  count               = signum(var.enable_private_endpoint ? 1 : 0)
  name                = azurerm_private_endpoint.pep.0.name
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_api_management.api_management]
}

data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_api_management.api_management]
}

resource "azurerm_private_dns_zone" "dns_zone" {
  count               = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = var.environment == "public" ? "${local.apim_name}.azure-api.net" : "${local.apim_name}.azure-api.us"
  resource_group_name = local.resource_group_name
  tags                = merge({ "Name" = format("%s", "Azure-APIM-Private-DNS-Zone") }, var.add_tags, )
}

resource "azurerm_private_dns_zone" "apim_dev_portal_dns_zone" {
  count               = var.existing_apim_dev_portal_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = var.environment == "public" ? "${local.apim_dev_portal_fqdn}.azure-api.net" : "${local.apim_dev_portal_fqdn}.azure-api.us"
  resource_group_name = local.resource_group_name
  tags                = merge({ "Name" = format("%s", "Azure-APIM-DEV-PORTAL-Private-DNS-Zone") }, var.add_tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  count                 = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                  = "vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.dns_zone.0.name : var.existing_private_dns_zone
  virtual_network_id    = data.azurerm_virtual_network.vnet.0.id
  registration_enabled  = false
  tags                  = merge({ "Name" = format("%s", "Azure-APIM-Private-DNS-Zone") }, var.add_tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "apim_dev_portalvnet_link" {
  count                 = var.existing_apim_dev_portal_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                  = "apim-dev-portal-vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = var.existing_apim_dev_portal_dns_zone == null ? azurerm_private_dns_zone.apim_dev_portal_dns_zone.0.name : var.existing_apim_dev_portal_dns_zone
  virtual_network_id    = data.azurerm_virtual_network.vnet.0.id
  registration_enabled  = false
  tags                  = merge({ "Name" = format("%s", "Azure-APIM-DEV-PORTAL-Private-DNS-Zone") }, var.add_tags, )
}

resource "azurerm_private_dns_a_record" "a_rec" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = lower(azurerm_api_management.api_management.name)
  zone_name           = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.dns_zone.0.name : var.existing_private_dns_zone
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.pip.0.private_service_connection.0.private_ip_address]
}

resource "azurerm_private_dns_a_record" "apim_dev_portal_a_rec" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = lower(local.apim_dev_portal_fqdn)
  zone_name           = var.existing_apim_dev_portal_dns_zone == null ? azurerm_private_dns_zone.apim_dev_portal_dns_zone.0.name : var.existing_apim_dev_portal_dns_zone
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_api_management.apim.private_ip_addresses.0]
}
