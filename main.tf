resource "azurerm_resource_group" "arg" {
  name     = var.RGN
  location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = var.location
  resource_group_name = azurerm_resource_group.arg.name
  address_space       = [var.CIDR]
}

resource "azurerm_subnet" "pbsb" {
  name                 = "Public"
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "prsb" {
  name                 = "Private"
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.3.0/24"]
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

resource "azurerm_subnet_network_security_group_association" "pbsbNsg" {
  subnet_id                 = azurerm_subnet.pbsb.id
  network_security_group_id = azurerm_network_security_group.pbnsg.id
}

resource "azurerm_subnet_network_security_group_association" "prsbNsg" {
  subnet_id                 = azurerm_subnet.prsb.id
  network_security_group_id = azurerm_network_security_group.prnsg.id
}

resource "azurerm_availability_set" "pbas" {
  name                = "PublicAS"
  location            = var.location
  resource_group_name = azurerm_resource_group.arg.name
}

resource "azurerm_availability_set" "pras" {
  name                = "PrivateAS"
  location            = var.location
  resource_group_name = azurerm_resource_group.arg.name
}

module "PublicVM" {
source                = "./modules/windowsvm"
   count                 = 2
   nicName               = "pbNIC${count.index}"
   location              = var.location
   resource_group_name   = azurerm_resource_group.arg.name
   ipconfname            = "ipConf${count.index}"
   subnet_id             = azurerm_subnet.pbsb.id
   private_ip_address_allocation = "Dynamic"
   VMname                = "PublicVM${count.index}"
   availability_set_id   = azurerm_availability_set.pbas.id
   VMsize                = var.VMsize
   computer_name         = "PBVM${count.index}"
   admin_username        = var.admin_username
   admin_password        = var.admin_password
   DCname                = "PBdisc${count.index}"
   create_option         = "FromImage"
   os_type               = "Windows"
   publisher             = "MicrosoftWindowsServer"
   offer                 = "WindowsServer"
   sku                   = "2019-Datacenter"
   OSversion             = "latest"
   caching               = "ReadWrite"
   managed_disk_type     = "StandardSSD_LRS"
   disk_size_gb          = "127"
}

module "PrivateVM" {
source                = "./modules/linuxvm"
   count                 = 2
   nicName               = "prNIC${count.index}"
   location              = var.location
   resource_group_name   = azurerm_resource_group.arg.name
   ipconfname            = "ipConf${count.index}"
   subnet_id             = azurerm_subnet.prsb.id
   private_ip_address_allocation = "Dynamic"
   VMname                = "PrivateVM${count.index}"
   availability_set_id   = azurerm_availability_set.pras.id
   VMsize                = var.VMsize
   computer_name         = "PRVM${count.index}"
   admin_username        = var.admin_username
   admin_password        = var.admin_password
   DCname                = "PVdisc${count.index}"
   create_option         = "FromImage"
   os_type               = "Linux"
   publisher             = "Canonical"
   offer                 = "UbuntuServer"
   sku                   = "18.04-LTS"
   OSversion             = "latest"
   caching               = "ReadWrite"
   managed_disk_type     = "StandardSSD_LRS"
   disk_size_gb          = "127"
}