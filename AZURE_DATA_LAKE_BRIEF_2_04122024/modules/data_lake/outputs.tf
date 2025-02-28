output "storage_account_id" {
  description = "ID du compte de stockage"
  value       = azurerm_storage_account.adls.id
}

output "storage_account_primary_blob_endpoint" {
  description = "Point de terminaison primaire du Blob Storage"
  value       = azurerm_storage_account.adls.primary_blob_endpoint
}
