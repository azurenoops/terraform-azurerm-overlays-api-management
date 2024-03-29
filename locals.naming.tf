locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name              = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location                         = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  apim_name                        = coalesce(var.apim_custom_name, data.azurenoopsutils_resource_name.apim.result)
  apim_dev_portal_fqdn             = "${local.apim_name}-developer"
  apim_pip_name                    = data.azurenoopsutils_resource_name.pip_name.result
  apim_nsg_name                    = data.azurenoopsutils_resource_name.nsg.result
  apim_user_assigned_identity_name = data.azurenoopsutils_resource_name.identity.result
  apim_app_insights_name           = "${local.apim_name}-appin"
  apim_logger_name                 = "${local.apim_name}-logger"
}
