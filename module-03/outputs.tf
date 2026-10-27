output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "The name of the created Resource Group."
}

output "name_prefix" {
  value       = local.name_prefix
  description = "The prefix used for all resource names."
}

output "public_ip_address" {
  value       = azurerm_public_ip.main.ip_address
  description = "The public IP address of the created VM."
}



/* output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the created Storage Account."
} */