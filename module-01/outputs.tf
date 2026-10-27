output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the created Resource Group."
}

/* output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the created Storage Account."
} */