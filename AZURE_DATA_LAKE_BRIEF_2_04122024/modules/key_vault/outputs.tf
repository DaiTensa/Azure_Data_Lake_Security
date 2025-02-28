// Exporter l'ID du Key Vault
output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

// Exporter le client ID du service principal principal (sp_primary)
output "sp_primary_client_id" {
  value = azuread_service_principal.sp_primary_p1.client_id
}

output "app_secret_s1" {
  value     = azuread_application_password.sp_password_s1.value
  sensitive = true
}

// Exporte le nom du key vault
output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}







