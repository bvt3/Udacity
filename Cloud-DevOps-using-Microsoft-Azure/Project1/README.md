# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
**Your words here**

### Output
Below is the expected output of the terraform apply command:

Outputs:

azurerm_lb_frontend_ip_configuration = tolist([
  {
    "availability_zone" = "No-Zone"
    "gateway_load_balancer_frontend_ip_configuration_id" = ""
    "id" = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/Project1/providers/Microsoft.Network/loadBalancers/prj1-lb/frontendIPConfigurations/prj1-lbfrontendip"
    "inbound_nat_rules" = toset([])
    "load_balancer_rules" = toset([])
    "name" = "prj1-lbfrontendip"
    "outbound_rules" = toset([])
    "private_ip_address" = ""
    "private_ip_address_allocation" = "Dynamic"
    "private_ip_address_version" = ""
    "public_ip_address_id" = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/Project1/providers/Microsoft.Network/publicIPAddresses/prj1-pip"
    "public_ip_prefix_id" = ""
    "subnet_id" = ""
    "zones" = tolist([])
  },
])
vm_name = [
  "prj1-vm1",
  "prj1-vm2",
]

