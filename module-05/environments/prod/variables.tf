# Environment (The Execution Context): Contains the actual, hardcoded configuration values. 
# These are typically stored in a .tfvars file (e.g., dev.tfvars), defining specific parameters 
# (like location = "West Europe" or vm_size = "Standard_B2s").


variable "student_id" { type = string }
variable "subscription_id" { type = string }
variable "project_name"    { type = string }
variable "location"   { type = string }
