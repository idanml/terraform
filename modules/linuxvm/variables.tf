variable resource_group_name {
  type        = string
}

variable location {
  type        = string
}

variable nicName {
  type        = string
}

variable subnet_id {
  type        = string
}

variable private_ip_address_allocation {
  type        = string
}

variable ipconfname {
  type        = string
}

variable VMname {
  type        = string
}

 variable availability_set_id {
   type        = string
 }
 
 variable computer_name {
   type        = string
 }
 
variable DCname {
  type        = string
}

variable create_option {
  type        = string
  default     = "FromImage"
}

 variable disk_size_gb {
   type        = string
 }
 
 variable os_type {
   type        = string
 }

 variable managed_disk_type {
   type        = string
 }

variable admin_username {
   type        = string
}
 
variable admin_password {
   type        = string
}

variable VMsize {
  type        = string
}

variable publisher {
  type        = string
}

variable offer {
   type        = string
 }
 
 variable sku {
   type        = string
 }

 variable OSversion {
   type        = string
 }
 
 variable caching {
   type        = string
 }
 
 