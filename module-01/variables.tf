variable "subscription_id" {
  type        = string
  default     = "7a3c6854-0fe1-42eb-b5b9-800af1e53d70"
  description = "Azure Subscription ID for TISIP Fagskole Undervisning"
}

variable "location" {
  type        = string
  default     = "norwayeast"
  description = "Target Azure region for resource deployment."
}

variable "project_name" {
  type        = string
  default     = "mod01"
  description = "Short prefix, for consistent resource naming."
}