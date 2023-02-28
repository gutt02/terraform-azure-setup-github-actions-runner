output "virtual_network_id" {
  value       = azurerm_virtual_network.this.id
  description = "Id of the Virtual Network."
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.this.name
  description = "Name of the Virtual Network."
}
