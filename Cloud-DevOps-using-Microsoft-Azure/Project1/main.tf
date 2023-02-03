locals {
  assert_vm_count = var.vm_count < 2 || var.vm_count > 5 ? file("ERROR: At least two to five VMs are required") : null
}

terraform {
   required_version = ">=0.12"

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.0"
     }
   }
 }

 provider "azurerm" {
   features {}
 }

 resource "azurerm_resource_group" "project1" {
   name     = var.resource_group_name
   location = var.location
   tags = var.tags
 }

 resource "azurerm_virtual_network" "project1" {
   name                = "prj1-vn"
   location            = azurerm_resource_group.project1.location
   resource_group_name = azurerm_resource_group.project1.name
   address_space       = ["10.0.0.0/16"]
   tags = var.tags
 }

 resource "azurerm_subnet" "project1" {
   name                 = "prj1-subnet"
   resource_group_name  = azurerm_resource_group.project1.name
   virtual_network_name = azurerm_virtual_network.project1.name
   address_prefixes     = ["10.0.2.0/24"]
 }

 resource "azurerm_network_interface" "project1" {
   count               = var.vm_count
   name                = "prj1-nic${count.index + 1}"
   location            = azurerm_resource_group.project1.location
   resource_group_name = azurerm_resource_group.project1.name

   ip_configuration {
     name                          = "prj1-ipconfig${count.index + 1}"
     subnet_id                     = azurerm_subnet.project1.id
     private_ip_address_allocation = "Dynamic"
   }

   tags = var.tags
 }

 resource "azurerm_public_ip" "project1" {
   name                         = "prj1-pip"
   location                     = azurerm_resource_group.project1.location
   resource_group_name          = azurerm_resource_group.project1.name
   allocation_method            = "Static"
   domain_name_label            = "prj1fqdn"
   sku                          = "Standard"
   tags = var.tags
 }

 resource "azurerm_lb" "project1" {
   name                = "prj1-lb"
   location            = azurerm_resource_group.project1.location
   resource_group_name = azurerm_resource_group.project1.name
   sku                 = "Standard"

   frontend_ip_configuration {
     name                          = "prj1-lbfrontendip"
     public_ip_address_id          = azurerm_public_ip.project1.id
     private_ip_address_allocation = "Dynamic"
   }

   tags = var.tags
 }

 resource "azurerm_lb_backend_address_pool" "project1" {
   loadbalancer_id     = azurerm_lb.project1.id
   name                = "prj1-beap"
 }

 resource "azurerm_lb_probe" "project1" {
   resource_group_name = azurerm_resource_group.project1.name
   loadbalancer_id     = azurerm_lb.project1.id
   name                = "prj1-probe"
   port                = var.application_port
 }

 resource "azurerm_lb_rule" "project1" {
   resource_group_name            = azurerm_resource_group.project1.name
   loadbalancer_id                = azurerm_lb.project1.id
   name                           = "lb-inbound-rule"
   protocol                       = "Tcp"
   frontend_port                  = 80
   backend_port                   = 80
   backend_address_pool_id        = azurerm_lb_backend_address_pool.project1.id
   frontend_ip_configuration_name = "prj1-lbfrontendip"
   probe_id                       = azurerm_lb_probe.project1.id
 }

 resource "azurerm_network_interface_backend_address_pool_association" "project1" {
   count                   = var.vm_count
   network_interface_id    = azurerm_network_interface.project1.*.id[count.index]
   ip_configuration_name   = azurerm_network_interface.project1.*.ip_configuration.0.name[count.index]
   backend_address_pool_id = azurerm_lb_backend_address_pool.project1.id
 }

 resource "azurerm_availability_set" "availset" {
   name                         = "prj1-availset"
   location                     = azurerm_resource_group.project1.location
   resource_group_name          = azurerm_resource_group.project1.name
   platform_fault_domain_count  = var.vm_count > 3 ? 3 : var.vm_count
   platform_update_domain_count = var.vm_count > 3 ? 3 : var.vm_count
   managed                      = true
   tags = var.tags
 }

 data "azurerm_resource_group" "image" {
   name                = var.packer_resource_group_name
 }

 data "azurerm_image" "image" {
   name                = var.packer_image_name
   resource_group_name = data.azurerm_resource_group.image.name
 }

 resource "azurerm_network_security_group" "project1" {
   name                = "prj1-nsg"
   location            = azurerm_resource_group.project1.location
   resource_group_name = azurerm_resource_group.project1.name
   tags = var.tags
 }

 resource "azurerm_network_security_rule" "example" {
   for_each                    = local.nsgrules 
   name                        = each.value.name
   direction                   = each.value.direction
   access                      = each.value.access
   priority                    = each.value.priority
   protocol                    = each.value.protocol
   source_port_range           = each.value.source_port_range
   destination_port_range      = each.value.destination_port_range
   source_address_prefix       = each.value.source_address_prefix
   destination_address_prefix  = each.value.destination_address_prefix
   resource_group_name         = azurerm_resource_group.project1.name
   network_security_group_name = azurerm_network_security_group.project1.name
 }

 resource "azurerm_subnet_network_security_group_association" "nsg-association" {
   subnet_id                 = azurerm_subnet.project1.id
   network_security_group_id = azurerm_network_security_group.project1.id
 }

 resource "azurerm_virtual_machine" "project1" {
   count                 = var.vm_count
   name                  = "prj1-vm${count.index + 1}"
   location              = azurerm_resource_group.project1.location
   availability_set_id   = azurerm_availability_set.availset.id
   resource_group_name   = azurerm_resource_group.project1.name
   network_interface_ids = [element(azurerm_network_interface.project1.*.id, count.index)]
   vm_size               = "Standard_B1s"
   # vm_size               = "Standard_DS1_v2"

   delete_os_disk_on_termination = true
   delete_data_disks_on_termination = true

   storage_image_reference {
     id = "${data.azurerm_image.image.id}"
   }

   storage_os_disk {
     name              = "osdisk${count.index + 1}"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   storage_data_disk {
     name              = "datadisk${count.index + 1}"
     managed_disk_type = "Standard_LRS"
     create_option     = "Empty"
     lun               = 0
     disk_size_gb      = "1023"
   }

   os_profile {
     computer_name  = "mylab${count.index + 1}"
     admin_username = var.admin_user
     admin_password = var.admin_password
   }

   os_profile_linux_config {
     disable_password_authentication = false
   }   

   tags = var.tags
 }
