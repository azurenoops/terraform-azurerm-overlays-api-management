# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# Outputs    ##
###############

output "apim_id" {
    value = data.azurerm_api_management.apim.id
}

output "apim_name" {
    value = data.azurerm_api_management.apim.name
}


