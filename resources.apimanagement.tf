resource "azurerm_public_ip" "apim_pip" {
  # To deploy APIM to the stv2 platform, you must specify a public IP address else it will deploy to stv1. 
  # The stv2 platform currently is not supported in Azure USGovernment.  Remove this check when stv2 is supported in Azure US Government. 
  #count = var.environment == "public" ? 1 : 0
  name = local.apim_pip_name
  resource_group_name = local.resource_group_name
  location = local.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = lower(local.apim_pip_name)
  tags = merge(var.add_tags, local.default_tags)
}
resource "azurerm_api_management" "api_management" {
  depends_on = [
    azurerm_user_assigned_identity.apim_identity,
    azurerm_public_ip.apim_pip,
    azurerm_subnet_network_security_group_association.apim-subnet-nsg-association
  ]
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
  name                = local.apim_name
  location            = local.location
  resource_group_name = local.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email

  min_api_version     = var.min_api_version 
  public_ip_address_id = azurerm_public_ip.apim_pip.id
  sku_name             = local.sku_name
  virtual_network_type = var.virtual_network_type
  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.apim_subnet.id
  }
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.apim_identity.id 
    ]
  }
  tags = merge(var.add_tags, local.default_tags)
}

resource "azurerm_api_management_redis_cache" "api_management_redis_cache" {
  #count = var.enable_redis_cache ? 1 : 0
  depends_on = [
    azurerm_api_management.api_management,
    module.mod_redis_cache
  ]
  name              = lower(module.mod_redis_cache.0.redis_name)
  api_management_id = azurerm_api_management.api_management.id
  connection_string = data.azurerm_redis_cache.redis_cache.primary_connection_string
  description       = "Redis cache instances"
  redis_cache_id    = data.azurerm_redis_cache.redis_cache.id
  cache_location    = local.location
}

resource "azurerm_private_dns_zone" "apim_dns_zone" {
depends_on = [
  azurerm_api_management.api_management
]
  count               = var.existing_apim_private_dns_zone == null ? 1 : 0
  name                = var.environment == "public" ? "${local.apim_name}.azure-api.net" : "${local.apim_name}.azure-api.us"
  resource_group_name = local.resource_group_name
  tags                = merge({ "Name" = format("%s", "Azure-APIM-Private-DNS-Zone") }, var.add_tags, )
}
resource "azurerm_private_dns_zone_virtual_network_link" "apim_vnet_link" {
  name                  = "apim-vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = var.existing_apim_private_dns_zone == null ? azurerm_private_dns_zone.apim_dns_zone.0.name : var.existing_apim_private_dns_zone
  virtual_network_id    = var.existing_vnet_id == null ? data.azurerm_virtual_network.vnet.id : var.existing_vnet_id
  registration_enabled  = false
  tags                  = merge({ "Name" = format("%s", "Azure-APIM-Private-DNS-Zone") }, var.add_tags, )
}
resource "azurerm_private_dns_zone" "apim_dev_portal_dns_zone" {
depends_on = [
  azurerm_api_management.api_management
]
  count               = var.existing_apim_dev_portal_dns_zone == null ? 1 : 0
  name                = var.environment == "public" ? "${local.apim_dev_portal_fqdn}.azure-api.net" : "${local.apim_dev_portal_fqdn}.azure-api.us"
  resource_group_name = local.resource_group_name
  tags                = merge({ "Name" = format("%s", "Azure-APIM-Private-DNS-Zone") }, var.add_tags, )
}
resource "azurerm_private_dns_zone_virtual_network_link" "apim_dev_portalvnet_link" {
  name                  = "apim-dev-portal-vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = var.existing_apim_dev_portal_dns_zone == null ? azurerm_private_dns_zone.apim_dev_portal_dns_zone.0.name : var.existing_apim_dev_portal_dns_zone
  virtual_network_id    = var.existing_vnet_id == null ? data.azurerm_virtual_network.vnet.id : var.existing_vnet_id
  registration_enabled  = false
  tags                  = merge({ "Name" = format("%s", "Azure-APIM-Private-DNS-Zone") }, var.add_tags, )
}

resource "azurerm_private_dns_a_record" "apim_a_rec" {
  name                = lower(local.apim_name)
  zone_name           = var.existing_apim_private_dns_zone == null ? azurerm_private_dns_zone.apim_dns_zone.0.name  : var.existing_apim_private_dns_zone
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_api_management.apim.private_ip_addresses.0]
}
resource "azurerm_private_dns_a_record" "apim_dev_portal_a_rec" {
  name                = lower(local.apim_dev_portal_fqdn)
  zone_name           = var.existing_apim_dev_portal_dns_zone == null ? azurerm_private_dns_zone.apim_dev_portal_dns_zone.0.name  : var.existing_apim_dev_portal_dns_zone
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_api_management.apim.private_ip_addresses.0]
}