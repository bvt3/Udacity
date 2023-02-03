locals { 
  nsgrules = {

    AllowLoadBalancerInbound = {
      name                       = "AllowLoadBalancerInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range    = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
 
    AllowApplicationInbound = {
      name                       = "AllowApplicationInbound"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowApplicationOutbound = {
      name                       = "AllowApplicationOutbound"
      priority                   = 300
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }
 
    DenyAllInbound = {
      name                       = "DenyAllInbound"
      priority                   = 400
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
 
}