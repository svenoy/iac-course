resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-assignment"
  location = var.location
}

/* resource "azurerm_storage_account" "sa" {
  # Modify name if necessary to ensure a globally unique name
  name                     = "st${var.project_name}stigs"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
} */