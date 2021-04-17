resource "azurerm_network_interface" "NIC" {
  name                = var.nicName
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ipconfname
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.VMname
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.NIC.id]
  availability_set_id   = var.availability_set_id
  vm_size               = var.VMsize

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.OSversion
 }

  os_profile_linux_config{
  disable_password_authentication = false
  }

  os_profile {
     computer_name      = var.computer_name
     admin_username     = var.admin_username
     admin_password     = var.admin_password
  }

   storage_os_disk {
      name              = var.DCname
      create_option     = var.create_option
      caching           = var.caching
      managed_disk_type = var.managed_disk_type
      disk_size_gb      = var.disk_size_gb 
   }
}