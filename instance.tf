#demo instance:
resource "azurerm_virtual_machine" "demo-vm" {
   name                  = "${var.prefix}-vm"
   location              = "East US"
   resource_group_name   = azurerm_resource_group.demo.name 
   network_interface_ids = [azurerm_network_interface.demo-vm.id]
   vm_size                = "Standard_B1ls"
#this is a demo instance, so we can delete all data on termiantion 
#delete_os_disk_on_termination = True
#delete_data_disks_on_termination = true

storage_image_reference {
  publisher  = "canonical"
  offer      = "UbuntuServer"
  sku        = "16.04-LTS"
  version    = "latest"
}
storage_os_disk {
  name       = "myosdisk1"
  caching    = "ReadWrite"
  create_option = "FromImage"
  managed_disk_type = "Standard_LRS"
}
os_profile {
  computer_name = "demo-vm"
  admin_username = "demo"
  #admin_password = "..."
}
os_profile_linux_config {
  disable_password_authentication = true
  ssh_keys {
    key_data = file("mykey.pub")
    path   = "/home/demo/.ssh/authorized_keys"
  }
 }
}
  
resource "azurerm_network_interface" "demo-vm" {
  name                  = "${var.prefix}-instance01"
  location              = "East US"
  resource_group_name   = azurerm_resource_group.demo.name


   ip_configuration { 
   name             = "instance01"
   subnet_id         = azurerm_subnet.demo-internal01-1.id
   private_ip_address_allocation  = "Dynamic"
   public_ip_address_id     = azurerm_public_ip.demo-vm.id 
 }
}

resource "azurerm_public_ip" "demo-vm" {
   name                  = "instance01-public-ip"
   location              = "East US"
   resource_group_name   = azurerm_resource_group.demo.name
   allocation_method = "Dynamic"
}
