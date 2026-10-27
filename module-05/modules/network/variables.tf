# Modules (The Building Blocks): Contain variable blocks without default values. They dictate what 
# data is required to build the resource (e.g., a generic vnet_cidr variable).

# Once declared here in the child's variables, the module understands what var.student_id  
# and var.project_name refer to. Variable values are passed from the root module to the 
# child module through a module block (in root module's main.tf).
# This file declares or reflects expected inputs from caller i.e. the root module (through variables).


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