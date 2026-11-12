# Modules (The Building Blocks): Contain variable blocks without default values. They dictate what 
# data is required to build the resource (e.g., a generic vnet_cidr variable).

# Once declared here in the child's variables, the module understands what var.student_id  
# and var.project_name refer to. Variable values are passed from the root module to the 
# child module through a module block (in root module's main.tf).
# This file declares or reflects expected inputs from caller i.e. the root module (through variables).


variable "location" { type = string }

variable "resource_group_name" {
  description = "RG will typically be created in the root (parent) module"
  type        = string
}

variable "student_id" {
  type = string
}

variable "project_name" {
  type        = string
  description = "Name of the project component."

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "project_name can only contain lowercase letters, numbers, and hyphens (3–20 characters)."
  }
}

# Added in part F of Module 9, to prevent insecure NSG rules. Default is "VirtualNetwork" to allow 
# SSH from other resources in the same VNet.
variable "ssh_source_prefix" {
  type        = string
  description = "Where SSH (port 22) is allowed from. Never use \"*\"."
  default     = "VirtualNetwork" # Azure's tag for traffic from the same virtual network.
}
