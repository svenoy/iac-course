# ==============================================================================
# TIER 3: ENVIRONMENT (e.g., environments/dev/main.tf)
# CONCEPT: The Execution Context
# ROLE: The entry point where Terraform commands (init/plan/apply) are executed.
# FLOW:
#   - IN: Reads concrete, environment-specific values from local .tfvars files (e.g., dev.tfvars).
#   - OUT: Invokes the Stack via a 'module' block and injects these concrete values downward.
# STATE: Defines where the unique state file (.tfstate) for this specific environment is stored.
# ==============================================================================

# environments/dev/main.tf and environments/prod/main.tf are (identical) ROOT main files.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.location
}

module "stack" {
  source              = "../../stacks"
  student_id          = var.student_id
  subscription_id     = var.subscription_id
  project_name        = var.project_name       # Pass the raw string instead of local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}