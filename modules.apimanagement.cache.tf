module "mod_redis_cache" {
  depends_on = [
    module.mod_scaffold_rg
  ]
  source                       = "azurenoops/overlays-redis/azurerm"
  version                      = "~> 1.0.0"
  count                        = var.enable_redis_cache ? 1 : 0
  location                     = lower(local.location)
  org_name                     = lower(var.org_name)
  environment                  = lower(var.environment)
  workload_name                = lower(var.workload_name)
  existing_resource_group_name   = local.resource_group_name
  enable_private_endpoint      = false
  existing_subnet_name         = var.private_endpoint_subnet_name
  virtual_network_name         = var.virtual_network_name
  
  // Tags
  add_tags = merge(var.add_tags, local.default_tags) # Tags to be applied to all resources
}

