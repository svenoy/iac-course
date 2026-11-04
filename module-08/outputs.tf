output "resource_group_name" {
  # Since the stack now receives the RG name as an input variable, 
  # we must output the variable, not the resource:
  value       = var.resource_group_name
  description = "The name of the created Resource Group."
}

output "name_prefix" {
  value       = local.name_prefix
  description = "The prefix used for all resource names."
}

output "subnet_id" {
  value = module.network.subnet_id
}


/* output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the created Storage Account."
} */