variable "vm_count" {
   description = "Number of virtual machine to be created"
   default     = 2
   type = number
}

variable "packer_resource_group_name" {
   description = "Name of the resource group in which the Packer image is located"
   default     = "PackerImages"
}

variable "packer_image_name" {
   description = "Name of the Packer image"
   default     = "Ubuntu1804LTS-image"
}

variable "resource_group_name" {
   description = "Name of the resource group in which the resources will be created"
   default     = "Project1"
}

variable "location" {
   description = "Location where resources will be created"
   default = "southcentralus"
}

variable "tags" {
   description = "Map of the tags to use for the resources that are deployed"
   type        = map(string)
   default = {
      project = "Udacity project 1"
   }
}

variable "application_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 22
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "azureuser"
}

variable "admin_password" {
   description = "Default password for admin account"
   default     = "Password1234!"
}