resource "azurerm_linux_virtual_machine" "R14_EUSPRODWEBVM1" {
  admin_username                  = "sri"
  disable_password_authentication = false
  admin_password                  = "Welcome@1234"
  location                        = azurerm_resource_group.R1_EUSPRODRG.location
  resource_group_name             = azurerm_resource_group.R1_EUSPRODRG.name
  name                            = "EUSPRODWEBVM1"
  network_interface_ids           = [azurerm_network_interface.R10_EUSPRODWEBVM1-NIC.id]
  #size                            = "Standard_B1s"
  size = "Standard_B2s" #Refer to CRQNO 1234555653
  os_disk {
    name                 = "EUSPRODWEBVM1_OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

}


resource "azurerm_windows_virtual_machine" "R15_EUSPRODDBVM1" {
  admin_password        = "Welcome@1234"
  admin_username        = "sri"
  location              = azurerm_resource_group.R1_EUSPRODRG.location
  name                  = "EUSPRODDBVM1"
  network_interface_ids = [azurerm_network_interface.R12_EUSPRODDBVM1-NIC.id]
  resource_group_name   = azurerm_resource_group.R1_EUSPRODRG.name
  size                  = "Standard_B2s"
  os_disk {
    name                 = "EUSPRODDBVM1_OSDISK"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

}

resource "azurerm_managed_disk" "R16_EUSPRODDBVM1_DD2" {
  create_option        = "Empty"
  location             = azurerm_resource_group.R1_EUSPRODRG.location
  name                 = "EUSPRODDBVM1_DD2"
  resource_group_name  = azurerm_resource_group.R1_EUSPRODRG.name
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 32
}

resource "azurerm_virtual_machine_data_disk_attachment" "R17_EUSPRODDBVM1_DD2_Attach" {
  managed_disk_id    = azurerm_managed_disk.R16_EUSPRODDBVM1_DD2.id
  virtual_machine_id = azurerm_windows_virtual_machine.R15_EUSPRODDBVM1.id
  lun                = "0"
  caching            = "ReadWrite"
}