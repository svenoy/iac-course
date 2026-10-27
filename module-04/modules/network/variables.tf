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