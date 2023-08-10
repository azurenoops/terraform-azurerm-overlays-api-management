# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_apim" {
  depends_on = [
    azurerm_resource_group.apim_rg,
    azurerm_virtual_network.apim_vnet,
    azurerm_subnet.apim_subnet,
    azurerm_subnet.pe_subnet
  ]
  source = "../.."
  #source  = "azurenoops/overlays-api-management/azurerm"
  #version = ">= 1.0.0"

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_maps_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  existing_resource_group_name = azurerm_resource_group.apim_rg.name
  location                     = module.mod_azure_region_lookup.location_cli
  environment                  = "public"
  deploy_environment           = "dev"
  org_name                     = "anoa"
  workload_name                = "apim"

  publisher_email = "apim_admins@microsoft.com"
  publisher_name  = "apim"

  sku_tier             = "Developer"
  sku_capacity         = 1
  enable_user_identity = true
  virtual_network_type = "Internal"
  apim_subnet_name     = azurerm_subnet.apim_subnet.name
  min_api_version      = "2019-12-01"

  # Creating Private Endpoint requires, VNet name to create a Private Endpoint
  # By default this will create a `"${local.apim_name}.azure-api.net"` DNS zone. if created in commercial cloud
  # To use existing subnet, specify `existing_private_subnet_name` with valid subnet name. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  # Private endpoints doesn't work If not using `existing_private_subnet_name` to create redis inside a specified VNet/Snet.
  enable_private_endpoint      = false
  
  # All services need to use an private subnet to create private endpoints.
  virtual_network_name         = azurerm_virtual_network.apim_vnet.name
  existing_private_subnet_name = azurerm_subnet.pe_subnet.name

  # This is to enable resource locks for the key vault. 
  enable_resource_locks = false

  # Tags
  add_tags = local.tags # Tags to be applied to all resources
}
