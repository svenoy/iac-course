# ==============================================================================
# TIER 1: MODULE (e.g., modules/network/main.tf)
# CONCEPT: The Generic Building Block
# ROLE: Defines the actual cloud resources (e.g., a virtual network).
# FLOW: 
#   - IN: Receives necessary configuration data from the Stack via variables.
#   - OUT: Returns generated resource attributes (e.g., an allocated IP or ID) back to the Stack via outputs.
# RULE: Must remain generic. No hardcoded environment-specific values (like "dev" or "West Europe") here.
# ==============================================================================

resource "azurerm_virtual_network" "this" {
  name                = "${local.name_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "this" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Added in step 5 of Module 8. (Subnet might be needed e.g. for a database server, later.)
resource "azurerm_subnet" "data" {
  name                 = "${local.name_prefix}-data-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Added in part F of Module 9, to simulate that an insecure NSG rule exists.
resource "azurerm_network_security_group" "this" {
  name                = "${local.name_prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_source_prefix # Never use "*" for this variable; use "VirtualNetwork" or a specific IP range.
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
