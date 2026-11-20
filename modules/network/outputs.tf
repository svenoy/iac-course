output "subnet_id" {
  value       = azurerm_subnet.app.id # Previously "this" (changed in M-10, part 1).
  description = "ID of subnet, necessary e.g. for a NIC card."
}
