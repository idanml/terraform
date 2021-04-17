variable subscriptionid {
  type        = string
}

variable clientid {
  type        = string
}

variable clientsecret {
  type        = string
}

variable tenantid {
  type        = string
}

variable RGN {
  type        = string
  description = "resource group name"
}

variable location {
  type        = string
  description = "location"
}

variable CIDR {
  type        = string
  description = "address space"
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