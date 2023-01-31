#output "public_ip_fqdn" {
#    value = azurerm_public_ip.project1.fqdn
#}

#output "ip_configuration" {
#    value = "${azurerm_network_interface.project1.*.ip_configuration}"
#}

#output "public_ip" {
#    value = "${azurerm_virtual_machine.project1.*.public_ip}"
#}

output "azurerm_lb_frontend_ip_configuration" {
  description = "the frontend_ip_configuration for the azurerm_lb resource"
  value       = azurerm_lb.project1.frontend_ip_configuration
}

output "vm_name" {
  description = "names of the virtual machines"
  value       = azurerm_virtual_machine.project1.*.name
}