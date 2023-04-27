module "mod_redis_cache" {
depends_on = [
  module.mod_scaffold_rg
]
  source                      = "azurenoops/overlays-redis/azurerm"
  version                     = "~> 1.0.0"
  count                       = var.enable_redis_cache ? 1 : 0
  location                    = lower(local.location)
  create_redis_resource_group = false
  use_location_short_name     = true # Use the short location name in the resource group name
  org_name                    = lower(var.org_name)
  environment                 = lower(var.environment)
  workload_name               = lower(var.workload_name)
  custom_resource_group_name  = local.resource_group_name
  enable_private_endpoint     = false
  existing_subnet_id          = data.azurerm_subnet.pe_subnet.id
  virtual_network_name        = var.virtual_network_name

  // Tags
  add_tags = merge(var.add_tags, local.default_tags) # Tags to be applied to all resources
}

