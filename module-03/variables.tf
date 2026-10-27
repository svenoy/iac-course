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
  default     = "mod03"
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


variable "ssh_public_key" {
  description = "Public SSH key for the admin user on the VM"
  type        = string
  // Not sensitive, so no sensitive = true.
}

variable "nsg_rules" {
  description = "Inbound rules for the NSG"
  type = list(object({
    name     = string
    priority = number
    port     = string
  }))
  default = [
    { name = "allow_ssh", priority = 100, port = "22" },
  { name = "allow_http", priority = 110, port = "80" }]
}