resource "azurerm_resource_group" "main" { // "main" is a tag used only within the tf files
  name     = local.resource_group_name
  location = var.location

  tags = {
    student = var.student_id
    course  = "iac"
  }
}

module "network" {
  source       = "./modules/network"
  student_id   = var.student_id
  project_name = var.project_name
  location     = azurerm_resource_group.main.location // Not a string, but a reference to one of the resources
  // The actual, used location in the end is the one from the resource group, not the variable
  // An implicit dependency is now created, so that right order of resource creation is ensured
  resource_group_name = azurerm_resource_group.main.name
}






/* resource "azurerm_storage_account" "sa" {
  # Modify name if necessary to ensure a globally unique name
  name                     = "ss963${var.project_name}sa"     // Updated in M03 (but not used in M03)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
} */