/* variable "shortname" {
  description = "Ditt unike kortnavn (små bokstaver og tall, 3-8 tegn)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.kortnavn))
    error_message = "kortnavn må være 3-8 tegn, kun små bokstaver og tall."
  }
} 
*/

variable "student_id" {
  type = string
  # No default – must be unique (see terraform.tfvars).
  description = "Unique student-ID. Used as prefix in all resource names."

  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.student_id))
    error_message = "student_id; 3-8 characters and only lowercase letters and numbers."
  }
}

variable "location" {
  type    = string
  default = "norwayeast"
}

variable "pipeline_principal_id" {
  description = "OBJECT-ID til service principal-en, ikke client-ID. Se seksjon 10 (i M6)."
  type        = string
}

locals {
  tags = {
    student = var.student_id # var.shortname
    course  = "iac"
    keep    = "true" // Retain the backend resources
  }
}