terraform {
  required_version = ">= 1.16.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {} # For module-06 where we are creating the backend resources, this is a placeholder. 
  # The actual backend config is provided via -backend-config=backend.hcl (see ../backend.hcl).
}

provider "azurerm" {
  features {}
}
