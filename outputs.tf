#################################################################
# OUTPUTS
#################################################################
output "id" {
  value       = azurerm_postgresql_flexible_server.this.id
  description = "The ID of the PostgreSQL Flexible Server."
}
