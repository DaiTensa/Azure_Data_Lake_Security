# Sécurité

- L'authentification se fait via un Service Principal Azure
- Les secrets sont stockés dans le fichier `terraform.tfvars` (à ne pas versionner)
- Le cluster est configuré en mode "singleUser" pour plus de sécurité

# Service Principal Databricks (sp_databricks_p1)

**Objectif** : Gestion des accès pour Databricks

```terraform
resource "azuread_application" "sp_databricks_p1" {
  display_name = "sp-databricks-${var.initial_firstname}${var.lastname}"
  owners       = [data.azuread_client_config.current.object_id]
}
```

**Rôles attribués** :
    - Storage Blob Data Contributor

    - Key Vault Secrets User

    - Key Vault Contributor

    - Storage Account Key Operator Service Role

    - Contributor (sur le Resource Group Databricks)

## Sécurisation des Secrets

### Gestion des Mots de Passe

Le mots de passe du SP :
1. Généré automatiquement
2. Stocké dans Key Vault
3. Configuré avec une date d'expiration (2025-05-05)

```terraform
resource "azuread_application_password" "sp_databricks_password" {
  application_id = azuread_application.sp_databricks_p1.id 
  end_date      = "2025-05-05T23:59:59Z"
}
```

### Secret Scope Databricks

Un Secret Scope dédié est créé pour Databricks :

```terraform
resource "databricks_secret_scope" "databricks_secret_scope" {
  name = "databricks-secret-scope-${var.initial_firstname}-${var.lastname}"
  keyvault_metadata {
    resource_id = azurerm_key_vault.kv.id
    dns_name    = azurerm_key_vault.kv.vault_uri
  }
}
```

## Maintenance

- Le cluster s'arrête automatiquement après 60 minutes d'inactivité
- La mise à jour du cluster peut se faire en modifiant les paramètres dans le code Terraform
- Les modifications doivent être appliquées avec `terraform apply`