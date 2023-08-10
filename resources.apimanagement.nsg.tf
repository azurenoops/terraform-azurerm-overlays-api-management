# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_network_security_group" "apim-nsg" {
  depends_on = [
  module.mod_scaffold_rg]
  name                = local.apim_nsg_name
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "Allow-APIM-Management-Traffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "Allow-Azure-Load-Balancer-Traffic"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6390"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "Allow-Azure-Storage-Traffic"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }
  security_rule {
    name                       = "Allow-Azure-SQL-Traffic"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql"
  }
  security_rule {
    name                       = "Allow-Azure-Key-Vault-Traffic"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureKeyVault"
  }
  tags = merge(var.add_tags, local.default_tags)
}
data "azurerm_network_security_group" "apim-nsg" {
  depends_on = [
    azurerm_network_security_group.apim-nsg
  ]
  name                = local.apim_nsg_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "apim-subnet-nsg-association" {
  subnet_id                 = data.azurerm_subnet.apim_subnet.id
  network_security_group_id = data.azurerm_network_security_group.apim-nsg.id
}
