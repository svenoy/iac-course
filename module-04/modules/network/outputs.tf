output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "ID of subnet, necessary e.g. for a NIC card."
}