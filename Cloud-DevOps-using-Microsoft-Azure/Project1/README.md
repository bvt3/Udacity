# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, I created a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository
2. Create your infrastructure as code

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Running the Packer template:

    a. Open the server.json file, in line 3, 4, and 5, you need to supply the client id, secret and subscription id from your Azure account respectively. 
    
    b. The Packer is dependent to an existing resource group, by default the resource group name is "PackerImages" in line 6, you need to pre-create this, using the Azure CLI command:  az group create --name PackerImages --location southcentralus
    
    c. The location is set by default to "South Central US", change this if necessary.
    
    d. Once you have created the resource group, run the packer command:  packer build server.json
    
3. Running the Terraform template:

    a. There are three files related to terraform, these are the main.tf, variables.tf and output.tf. You can run directly the terraform plan using the command:  terraform apply "solution.plan" 
    
    b. You can edit some of the default parameters by opening the file variables.tf. Here you can find and set variables like vm_count, location, etc. For example, the vm_count variable has a default value of 2, set this to a value of maximum 5. Only the two variables namely packer_resource_group_name and packer_image_name should not be change because it is dependent on the Packer template from before.
    
    c. And finally, once done, run the command "terraform destroy" to clean up the resources, and delete the packer image using the command: az image delete -g PackerImages -n Ubuntu1804LTS-image.

### Output
Below is the expected output of the terraform apply command, these are defined from output.tf, the azurerm_lb_frontend_ip_configuration and vm_name output variables.

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

### Miscellaneous files worth mentioning
1.  **policy_assignment_output.txt** - this is the result after running the command:  az policy assignment list
2.  **policy_assignment_screencap.jpg** - is equivalent of the above, but in a picture format
3.  **policy_violation_screenshot.jpg** - is a screen shot of a policy violation when the tag is not supplied during the deployment
4.  **terraform_apply_output.txt** - this is the result of the terraform command apply that shows no error


