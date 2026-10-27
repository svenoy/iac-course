### locals.tf
```terraform
locals {
  # Prefix for all resource names, based on student ID and project name.
  name_prefix = "${var.student_id}-${var.project_name}"

  resource_group_name = "${local.name_prefix}-rg"
}
```

### main.tf
```terraform
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


```
### outputs.tf
```terraform
output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "The name of the created Resource Group."
}

output "name_prefix" {
  value       = local.name_prefix
  description = "The prefix used for all resource names."
}

output "subnet_id" {
  value = module.network.subnet_id
}


/* output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the created Storage Account."
} */
```

### providers.tf
```terraform
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
```

### variables.tf
```terraform
variable "subscription_id" {
  type = string
  # No default – see terraform.tfvars.
  description = "Azure Subscription ID for TISIP Fagskole Undervisning"
}

variable "student_id" {
  type = string
  # No default – must be unique (see terraform.tfvars).
  description = "Unique student-ID. Used as prefix in all resource names."

  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.student_id))
    error_message = "student_id; 3-8 characters and only lowercase letters and numbers."
  }
}

variable "project_name" {
  type        = string
  default     = "mod04"
  description = "Short prefix, for consistent resource naming."

  validation {
    condition     = length(var.project_name) <= 10
    error_message = "Project name cannot be longer than 10 characters."
  }
}

variable "location" {
  type = string
  # No default – see terraform.tfvars.
  description = "Target Azure region for resource deployment."
}
```

### terraform.tfvars
```terraform
# ID (found via  az account show):
subscription_id = "7a3c6854-0fe1-42eb-b5b9-800af1e53d70"

# Must be unique for each student; used as prefix in all resource names.
student_id = "ss963"

# Target Azure region for resource deployment.
location = "norwayeast"
```

