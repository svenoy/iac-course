# ==============================================================================
# TIER 2: STACK (e.g., stacks/main.tf)
# CONCEPT: The Assembly Layer
# ROLE: Combines multiple independent modules (e.g., network + compute) into a cohesive infrastructure unit.
# FLOW:
#   - IN: Receives environment-specific data from the Environment tier.
#   - OUT: Maps and passes that data downward into the corresponding child modules.
#   - ROUTING: Captures outputs from one module (e.g., a network ID) and passes them as inputs 
#     to another module (e.g., a virtual machine).
# ==============================================================================
# RG (in this orignal root main.tf) is now created in (new) root environment i.e. environments/dev/main.tf.

resource "azurerm_resource_group" "main" { # The RG was added here in Module 6 (where environments are not used).
  name     = var.resource_group_name
  location = var.location

  tags = local.common_tags
}

module "network" {
  source = "git::https://github.com/svenoy/iac-course.git//modules/network?ref=network-v1.0.0"
  # Adjusted source for Module 8.
  project_name        = var.project_name
  student_id          = var.student_id
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# resource "random_password" "demo" {
#   length  = 24
#   special = true
# }
# This resource was a late addition. (random_password is from a new provider, so
# terraform init must be rerun, in the environment(s) / ultimate root folder(s)).