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

### outputs.tf
```terraform
output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "ID of subnet, necessary e.g. for a NIC card."
}
```

### variables.tf
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

