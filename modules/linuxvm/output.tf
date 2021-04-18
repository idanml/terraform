output "NIC_id" {
  value = azurerm_network_interface.NIC.id
}

output "VMPassword" {
  value       = var.admin_password
}