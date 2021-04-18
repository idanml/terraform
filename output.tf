output "PublicVM1Pass" {
  value       = module.PublicVM.0.VMPassword
  description = "The Password of the VM."
}

output "PublicVM2Pass" {
  value       = module.PublicVM.1.VMPassword
  description = "The Password of the VM."
}

output "PrivateVM1Pass" {
  value       = module.PrivateVM.0.VMPassword
  description = "The Password of the VM."
}

output "PrivateVM2Pass" {
  value       = module.PrivateVM.1.VMPassword
  description = "The Password of the VM."
}
