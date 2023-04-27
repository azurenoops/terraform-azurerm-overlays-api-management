locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  apim_name           = coalesce(var.apim_custom_name, data.azurenoopsutils_resource_name.apim.result)
  key_vault_name      = coalesce(var.key_vault_custom_name, data.azurenoopsutils_resource_name.keyvault.result)
  location_short      = module.mod_azregions.location_short
  apim_dev_portal_fqdn = "${local.apim_name}.developer"
  apim_pip_name       = "${local.apim_name}-pip"
  apim_nsg_name       = "${local.apim_name}-nsg"
  apim_user_assigned_identity_name = "${local.apim_name}Identity"
}
