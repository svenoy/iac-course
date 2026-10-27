### ./stacks/outputs.tf
```terraform
output "resource_group_name" {
  # Since the stack now receives the RG name as an input variable, 
  # we must output the variable, not the resource:
  value         = var.resource_group_name
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

### ./stacks/main.tf
```terraform
# RG (in this orignal root main.tf) is now created in (new) root environment i.e. environments/dev/main.tf.

module "network" {
  source       = "../modules/network"
  student_id   = var.student_id
  project_name = var.project_name
  location     = var.location
  resource_group_name = var.resource_group_name
}

resource "random_password" "demo" {
  length  = 24
  special = true
}
# This resource was a late addition. random_password is from a new provider, 
# so terraform init must be rerun (in the environments / root folders).
```

### ./stacks/variables.tf
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
  default     = "mod05"
  description = "Short prefix, for consistent resource naming."

  validation {
    condition     = length(var.project_name) <= 16
    error_message = "Project name cannot be longer than 16 characters."
  }
}

variable "location" {
  type = string
  # No default – see terraform.tfvars.
  description = "Target Azure region for resource deployment."
}

variable "resource_group_name" { type = string }
```

### ./stacks/locals.tf
```terraform
locals {
  # Prefix for all resource names, based on student ID and project name.
  name_prefix = "${var.student_id}-${var.project_name}"

  resource_group_name = "${local.name_prefix}-rg"
}
```

### ./stacks/providers.tf
```terraform
terraform {
  required_version = ">= 1.9.0"
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

```

### ./modules/network/outputs.tf
```terraform
output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "ID of subnet, necessary e.g. for a NIC card."
}
```

### ./modules/network/main.tf
```terraform
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
```

### ./modules/network/variables.tf
```terraform
# Once declared here in the child's variables, the module understands what var.student_id and var.project_name refer to.
# This file receives inputs from caller, i.e. the root module (through its variables).

variable "location"            { type = string }

variable "resource_group_name" { 
  description = "RG will typically be created in the root (parent) module"
  type = string 
}

variable "student_id" { 
  type = string 
}

variable "project_name" { 
  type = string 
}
```

### ./modules/network/locals.tf
```terraform
locals {
  # Prefix for all resource names, based on student ID and project name.
  name_prefix = "${var.student_id}-${var.project_name}"

  resource_group_name = "${local.name_prefix}-rg"
}
```

### ./environments/prod/main.tf
```terraform
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
```

### ./environments/prod/variables.tf
```terraform
variable "student_id" { type = string }
variable "subscription_id" { type = string }
variable "project_name"    { type = string }
variable "location"   { type = string }

```

### ./environments/prod/terraform.tfvars
```terraform
# ID (found via  az account show):
subscription_id = "7a3c6854-0fe1-42eb-b5b9-800af1e53d70"

# Must be unique for each student; used as prefix in all resource names.
student_id = "ss963"

project_name = "mod05-prod"
location = "norwayeast"
```

### ./environments/prod/locals.tf
```terraform
locals {
  # Prefix for all resource names, based on student ID and project name.
  name_prefix = "${var.student_id}-${var.project_name}"

  resource_group_name = "${local.name_prefix}-rg"
}
```

### ./environments/dev/main.tf
```terraform
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
```

### ./environments/dev/variables.tf
```terraform
variable "student_id" { type = string }
variable "subscription_id" { type = string }
variable "project_name"    { type = string }
variable "location"   { type = string }

```

### ./environments/dev/terraform.tfvars
```terraform
# ID (found via  az account show):
subscription_id = "7a3c6854-0fe1-42eb-b5b9-800af1e53d70"

# Must be unique for each student; used as prefix in all resource names.
student_id = "ss963"

project_name = "mod05-dev"
location = "norwayeast"
```

### ./environments/dev/locals.tf
```terraform
locals {
  # Prefix for all resource names, based on student ID and project name.
  name_prefix = "${var.student_id}-${var.project_name}"

  resource_group_name = "${local.name_prefix}-rg"
}
```

