#Create Virtual Network with 3 subnets
resource "azurerm_virtual_network" "R3_EUSPRODVNET1" {
  address_space       = ["10.100.0.0/16"]
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  name                = "EUSPRODVNET1"
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
}

resource "azurerm_subnet" "R4_WEBSUBNET" {
  address_prefixes     = ["10.100.10.0/24"]
  name                 = "WEBSUBNET"
  resource_group_name  = azurerm_resource_group.R1_EUSPRODRG.name
  virtual_network_name = azurerm_virtual_network.R3_EUSPRODVNET1.name
}

resource "azurerm_subnet" "R5_APPSUBNET" {
  address_prefixes     = ["10.100.20.0/24"]
  name                 = "APPSUBNET"
  resource_group_name  = azurerm_resource_group.R1_EUSPRODRG.name
  virtual_network_name = azurerm_virtual_network.R3_EUSPRODVNET1.name
}

resource "azurerm_subnet" "R6_DBSUBNET" {
  address_prefixes     = ["10.100.30.0/24"]
  name                 = "DBSUBNET"
  resource_group_name  = azurerm_resource_group.R1_EUSPRODRG.name
  virtual_network_name = azurerm_virtual_network.R3_EUSPRODVNET1.name
}

#Create Network Security Group
resource "azurerm_network_security_group" "R7_EUSPRODNSG" {
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
  name                = "EUSPRODNSG"

  security_rule {
    name                       = "LoginRules"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Create 2xPublic IPS for 2 Virtual machines  - Removed as per customer Request#123456789
#resource "azurerm_public_ip" "R8_EUSPRODWEBVM1-PIP" {
#  allocation_method   = "Static"
 # location            = azurerm_resource_group.R1_EUSPRODRG.location
 # name                = "EUSPRODWEBVM1-PIP"
 # resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
#}

resource "azurerm_public_ip" "R9_EUSPRODDBVM1-PIP" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  name                = "EUSPRODDBVM1-PIP"
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
}

#Create Network Interfaces for 2x Virtual Machines

resource "azurerm_network_interface" "R10_EUSPRODWEBVM1-NIC" {
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  name                = "EUSPRODWEBVM1-NIC"
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
  ip_configuration {
    name                          = "EUSPRODWEBVM1-NIC-CONFIG"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.R4_WEBSUBNET.id
    #public_ip_address_id          = azurerm_public_ip.R8_EUSPRODWEBVM1-PIP.id  #Removing Public IP based on Request No 123456789
  }
}

resource "azurerm_network_interface_security_group_association" "R11_EUSPRODWEBVM1-NIC-ASS1" {
  network_interface_id      = azurerm_network_interface.R10_EUSPRODWEBVM1-NIC.id
  network_security_group_id = azurerm_network_security_group.R7_EUSPRODNSG.id
}


resource "azurerm_network_interface" "R12_EUSPRODDBVM1-NIC" {
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  name                = "EUSPRODDBVM1-NIC"
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
  ip_configuration {
    name                          = "EUSPRODDBVM1-NIC-CONFIG"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.R6_DBSUBNET.id
    public_ip_address_id          = azurerm_public_ip.R9_EUSPRODDBVM1-PIP.id
  }
}

resource "azurerm_network_interface_security_group_association" "R13_EUSPRODDBVM1-NIC-ASS1" {
  network_interface_id      = azurerm_network_interface.R12_EUSPRODDBVM1-NIC.id
  network_security_group_id = azurerm_network_security_group.R7_EUSPRODNSG.id
}






































