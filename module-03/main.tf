resource "azurerm_resource_group" "main" { // "main" is a tag used only within the tf files
  name     = local.resource_group_name
  location = var.location

  tags = {
    student = var.student_id
    course  = "iac"
  }
}

resource "azurerm_virtual_network" "main" {
  name          = "${local.name_prefix}-vnet"
  address_space = ["10.0.0.0/16"]
  location      = azurerm_resource_group.main.location // Not a string, but a reference to one of the resources
  // The actual, used location in the end is the one from the resource group, not the variable
  // An implicit dependency is now created, so that right order of resource creation is ensured
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "${local.name_prefix}-snet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "${local.name_prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id                 // ID of subnet; reference to the resource (not a string)
  network_security_group_id = azurerm_network_security_group.main.id // ID of NSG; reference to the resource (not a string)
}


// VM should have a public IP, so we can SSH into it.
resource "azurerm_public_ip" "main" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${local.name_prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id // For part B of the assignment, we use a public IP (for SSH).
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${local.name_prefix}-vm"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.main.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key // Public key (not private key), will appear in terraform.tf state
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}




/* resource "azurerm_storage_account" "sa" {
  # Modify name if necessary to ensure a globally unique name
  name                     = "ss963${var.project_name}sa"     // Updated in M03 (but not used in M03)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
} */