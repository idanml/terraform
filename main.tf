resource "azurerm_resource_group" "arg" {
  name     = var.RGN
  location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = var.location
  resource_group_name = azurerm_resource_group.arg.name
  address_space       = [var.CIDR]

   subnet {
    name           = "Public"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.pbnsg.id
  } 
   subnet {
    name           = "Private"
    address_prefix = "10.0.3.0/24"
    security_group = azurerm_network_security_group.prnsg.id
  }

}

resource "azurerm_network_security_group" "pbnsg" {
  name                = "Public-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.arg.name
   security_rule {
    name                       = "RDPin"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
     security_rule {
    name                       = "8080in"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "RDPout"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
     security_rule {
    name                       = "8080out"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "prnsg" {
  name                = "Private-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.arg.name
   security_rule {
    name                       = "SSHin"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
     security_rule {
    name                       = "5432in"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "SSHout"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
     security_rule {
    name                       = "8080out"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}