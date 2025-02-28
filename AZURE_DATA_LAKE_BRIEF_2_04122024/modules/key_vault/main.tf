/*
La ressource data "azurerm_client_config" récupère des informations sur le client Azure 
actuellement connecté, comme le tenant ID, la subscription ID, etc.
*/

// Récupère des informations sur l'abonnement Azure principal.
data "azurerm_subscription" "primary" {}

// Récupère des informations sur le client Azure AD actuellement connecté
data "azuread_client_config" "current" {}

// Récupère des informations sur la configuration du client Azure
data "azurerm_client_config" "current_u" {}

// Création du Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = data.azuread_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
}

///////////////////////////////// SP PRINCIPAL //////////////////////////////////////

// Création d'une application azuread (Azure AD) pour le service principal sp_primary
resource "azuread_application" "sp_primary_p1" {
  display_name = "sp-principal-${var.initial_firstname}${var.lastname}"
  owners           = [data.azuread_client_config.current.object_id]
}

// Service principal associé à l'application azuread créée ci-dessus
resource "azuread_service_principal" "sp_primary_p1" {
  client_id = azuread_application.sp_primary_p1.client_id
  depends_on = [
    azuread_application.sp_primary_p1
  ]
}

# // Définition d'un rôle personnalisé pour gérer les User Delegation Keys et 
# // manipuler les fichiers dans le Data Lake
# resource "azurerm_role_definition" "sp_primary_role" {
#   name               = "DataLakeUserDelegationRole"
#   scope              = data.azurerm_subscription.primary.id

#   permissions {
#     actions = [
#       "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action",
#       "Microsoft.Storage/storageAccounts/blobServices/containers/read",           
#       "Microsoft.Storage/storageAccounts/blobServices/containers/write",          
#       "Microsoft.Storage/storageAccounts/blobServices/containers/delete"          
#     ]
#     not_actions = []
#   }

#   assignable_scopes = [
#     data.azurerm_subscription.primary.id,
#   ]
# }

# // Attribution du rôle au service principal
# resource "azurerm_role_assignment" "sp_primary_assignment" {
#   depends_on = [
#     azurerm_role_definition.sp_primary_role,
#     azuread_service_principal.sp_primary_p1
#   ]

#   scope              = data.azurerm_subscription.primary.id
#   role_definition_id = azurerm_role_definition.sp_primary_role.role_definition_resource_id
#   principal_id       = azuread_service_principal.sp_primary_p1.object_id
# }

# // Attribution du rôle Storage Blob Delegator au Service Principal sp_primary_p1
# resource "azurerm_role_assignment" "sp_primary_delegator" {
#   scope              = var.storage_account_id
#   role_definition_name = "Storage Blob Delegator"
#   principal_id       = azuread_service_principal.sp_primary_p1.object_id
# }

// Attribution du rôle Storage Blob Data Contributor au Service Principal sp_primary_p1
resource "azurerm_role_assignment" "sp_primary_contributor" {
  scope              = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id       = azuread_service_principal.sp_primary_p1.object_id
}

// Définition de la politique d'accès pour le service principal sp_primary_p1
resource "azurerm_key_vault_access_policy" "sp_primary_access_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current_u.tenant_id
  object_id    = azuread_service_principal.sp_primary_p1.object_id

  secret_permissions = [
    "Get",
    "List"
  ]

  depends_on = [
    azuread_service_principal.sp_primary_p1,
    azurerm_key_vault.kv
  ]
}

///////////////////////////////// SP SECONDAIRE //////////////////////////////////////

// Création d'une application azuread (Azure AD) pour le service principal sp_secondary
resource "azuread_application" "sp_secondary_s1" {
  display_name = "sp-secondaire-${var.initial_firstname}${var.lastname}"
  owners       = [data.azuread_client_config.current.object_id]
}

// Service principal associé à l'application azuread créée ci-dessus
resource "azuread_service_principal" "sp_secondary_s1" {
  client_id = azuread_application.sp_secondary_s1.client_id
  depends_on = [
    azuread_application.sp_secondary_s1
  ]
}

// Attribution du rôle Key Vault Secrets User au Service Principal sp_secondary_s1
resource "azurerm_role_assignment" "sp_secondary_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.sp_secondary_s1.object_id
}

// Attribution du rôle Key Vault Contributor au Service Principal sp_secondary_s1
resource "azurerm_role_assignment" "sp_secondary_kv_contributor" {
  scope              = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Contributor"
  principal_id       = azuread_service_principal.sp_secondary_s1.object_id
}

// Attribution du rôle Reader au Service Principal sp_secondary_s1
resource "azurerm_role_assignment" "sp_secondary_kv_reader" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sp_secondary_s1.object_id
}

// Définition de la politique d'accès pour le service principal sp_secondary_s1
resource "azurerm_key_vault_access_policy" "sp_secondary_access_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current_u.tenant_id
  object_id    = azuread_service_principal.sp_secondary_s1.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]

  depends_on = [
    azuread_service_principal.sp_secondary_s1,
    azurerm_key_vault.kv
  ]
}

// Création d'un mot de passe pour l'application sp_primary_p1
resource "azuread_application_password" "sp_password_p1" {
  application_id = azuread_application.sp_primary_p1.id 
  end_date        = "2025-03-05T23:59:59Z"
  depends_on = [
    azuread_application.sp_primary_p1  // S'assurer que l'application est créée en premier
  ]
}

// Stockage du mot de passe de sp_primary_p1 dans le Key Vault
resource "azurerm_key_vault_secret" "sp_primary_password" {
  name         = "secret-sp-principal"
  value        = azuread_application_password.sp_password_p1.value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    // azuread_application_password.sp_password_p1,  // S'assurer que le mot de passe est créé en premier
    azurerm_key_vault_access_policy.sp_primary_access_policy,  // S'assurer que la politique d'accès est créée en premier
    // azurerm_role_assignment.sp_primary_kv_access  // S'assurer que l'attribution de rôle est créée en premier
  ]
}

// Création d'un mot de passe pour l'application sp_secondary_s1
resource "azuread_application_password" "sp_password_s1" {
  application_id = azuread_application.sp_secondary_s1.id 
  end_date        = "2025-05-05T23:59:59Z"
  depends_on = [
    azuread_application.sp_secondary_s1  // S'assurer que l'application est créée en premier
  ]
}

// Stockage du mot de passe de sp_secondary_s1 dans le Key Vault
resource "azurerm_key_vault_secret" "sp_secondary_password" {
  name         = "secret-sp-secondaire"
  value        = azuread_application_password.sp_password_s1.value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    // azuread_application_password.sp_password_s1,  // S'assurer que le mot de passe est créé en premier
    azurerm_key_vault_access_policy.sp_secondary_access_policy,  // S'assurer que la politique d'accès est créée en premier
    // azurerm_role_assignment.sp_secondary_kv_access  // S'assurer que l'attribution de rôle est créée en premier
  ]
}

// Attribution du rôle Key Vault Secrets User au Service Principal sp_primary_p1
resource "azurerm_role_assignment" "sp_primary_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.sp_primary_p1.object_id
}

// Attribution du rôle Key Vault Contributor au Service Principal sp_primary_p1
resource "azurerm_role_assignment" "sp_primary_kv_contributor" {
  scope              = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Contributor"
  principal_id       = azuread_service_principal.sp_primary_p1.object_id
}

// Attribution du rôle Storage Account Key Operator Service Role au Service Principal sp_primary_p1
resource "azurerm_role_assignment" "sp_primary_sas_generator" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_service_principal.sp_primary_p1.object_id
}

///////////////////////////////Databricks////////////////////////////////////
/////////////////////Sécurisation du Databricks//////////////////////////////

// Création d'une application azuread (Azure AD) pour le service principal sp_databricks
resource "azuread_application" "sp_databricks_p1" {
  display_name = "sp-databricks-${var.initial_firstname}${var.lastname}"
  owners       = [data.azuread_client_config.current.object_id]
}

// Création d'un service principal pour l'application azuread sp_databricks
resource "azuread_service_principal" "sp_databricks_p1" {
  client_id  = azuread_application.sp_databricks_p1.client_id
  depends_on = [
    azuread_application.sp_databricks_p1
  ]
}

// Attribution du rôle Storage Blob Data Contributor au Service Principal sp_databricks_p1
resource "azurerm_role_assignment" "sp_databricks_contributor" {
  scope              = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id       = azuread_service_principal.sp_databricks_p1.object_id
}

// Attribution du rôle Key Vault Secrets User au Service Principal sp_databricks_p1
resource "azurerm_role_assignment" "sp_databricks_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.sp_databricks_p1.object_id
}

// Attribution du rôle Key Vault Contributor au Service Principal sp_databricks_p1
resource "azurerm_role_assignment" "sp_databricks_kv_contributor" {
  scope              = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Contributor"
  principal_id       = azuread_service_principal.sp_databricks_p1.object_id
}

// Attribution du rôle Storage Account Key Operator Service Role au Service Principal sp_databricks_p1
resource "azurerm_role_assignment" "sp_databricks_sas_generator" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_service_principal.sp_databricks_p1.object_id
}

resource "azurerm_key_vault_access_policy" "databricks_access_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azuread_client_config.current.tenant_id
  object_id    = azuread_service_principal.sp_databricks_p1.object_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

// Création d'un mot de passe pour l'application sp_databricks_p1
resource "azuread_application_password" "sp_databricks_password" {
  application_id = azuread_application.sp_databricks_p1.id 
  end_date        = "2025-05-05T23:59:59Z"
  depends_on = [
    azuread_application.sp_databricks_p1  // S'assurer que l'application est créée en premier
  ]
}

// Stockage du mot de passe de sp_databricks_p1 dans le Key Vault
resource "azurerm_key_vault_secret" "sp_databricks_password" {
  name         = "secret-sp-databricks"
  value        = azuread_application_password.sp_databricks_password.value
  key_vault_id = azurerm_key_vault.kv.id  
   depends_on = [
    azurerm_key_vault_access_policy.databricks_access_policy // S'assurer que la politique d'accès est créée en premier
  ]
}

resource "azurerm_role_assignment" "sp_databricks_add_contributor" {
  scope              = var.databricks_resource_group_id
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.sp_databricks_p1.object_id
}

# // Créer un Scret Scope pour le Databricks
# resource "databricks_secret_scope" "databricks_secret_scope" {
# name = "databricks-secret-scope-${var.initial_firstname}-${var.lastname}"

# keyvault_metadata {
#   resource_id = azurerm_key_vault.kv.id
#   dns_name = azurerm_key_vault.kv.vault_uri
# }
# }



