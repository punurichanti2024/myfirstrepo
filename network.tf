resource "azurerm_virtual_network" "demo" {
   name                  = "${var.prefix}-network"
   location              = "East US"
   resource_group_name   = azurerm_resource_group.demo.name
   address_space         = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-internal01-1" {
   name                  = "${var.prefix}-internal01-1"
   resource_group_name   = azurerm_resource_group.demo.name
   virtual_network_name  = azurerm_virtual_network.demo.name
   address_prefixes      = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "allow-ssh" {
   name                  = "${var.prefix}-allow-ssh"
   location              = "East US"
   resource_group_name   = azurerm_resource_group.demo.name
   
   security_rule {
       name       = "SSH"
       priority   = 1001
       direction  = "Inbound"
       access     = "Allow"
       protocol   = "Tcp"
       source_port_range  = "*"
       destination_port_range = "22"
       source_address_prefix  = var.ssh-source-address
       destination_address_prefix  = "*"
    }
}  
