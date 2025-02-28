# Sorties du Code Terraform

Les sorties générées par le code Terraform dans le fichier `main.tf`. Ce fichier appelle plusieurs modules pour créer et configurer des ressources Azure.

## Modules Utilisés

### Module `resource_group`

Ce module crée un groupe de ressources Azure.

- **Entrées :**
  - `rg_name` : Nom du groupe de ressources.
  - `rg_location` : Emplacement du groupe de ressources.

- **Sorties :**
  - `rg_name` : Nom du groupe de ressources créé.

### Module `data_lake`

Ce module crée un compte de stockage Azure Data Lake et des conteneurs de stockage.

- **Entrées :**
  - `rg_name` : Nom du groupe de ressources.
  - `storage_account` : Nom du compte de stockage.
  - `location` : Emplacement du compte de stockage.
  - `container_names` : Liste des noms des conteneurs à créer.

- **Sorties :**
  - `storage_account_id` : ID du compte de stockage créé.

### Module `key_vault`

Ce module crée un Azure Key Vault et configure les accès pour les Service Principals.

- **Entrées :**
  - `rg_name` : Nom du groupe de ressources.
  - `kv_name` : Nom du Key Vault.
  - `location` : Emplacement du Key Vault.
  - `initial_firstname` : Prénom de l'utilisateur initial.
  - `lastname` : Nom de famille de l'utilisateur initial.
  - `storage_account_id` : ID du compte de stockage (provenant du module `data_lake`).

- **Sorties :**
  - `key_vault_id` : ID du Key Vault créé.

### Module `databricks`

Ce module crée et configure un workspace Azure Databricks.

- **Entrées :**
  - `rg_name` : Nom du groupe de ressources.
  - `location` : Emplacement du workspace Databricks.

- **Sorties :**
  - `databricks_workspace_id` : ID du workspace Databricks créé.

### Module `monitoring`

Ce module configure la surveillance et le monitoring des ressources Azure.

- **Entrées :**
  - `rg_name` : Nom du groupe de ressources.
  - `location` : Emplacement des ressources de monitoring.

- **Sorties :**
  - `monitoring_workspace_id` : ID du workspace de monitoring créé.

## Résumé des Sorties

Après l'exécution du code Terraform, les sorties suivantes seront disponibles :

- `resource_group.rg_name` : Nom du groupe de ressources créé.
- `data_lake.storage_account_id` : ID du compte de stockage Azure Data Lake créé.
- `key_vault.key_vault_id` : ID du Key Vault créé.
- `databricks.databricks_workspace_id` : ID du workspace Databricks créé.
- `monitoring.monitoring_workspace_id` : ID du workspace de monitoring créé.


Le code Terraform dans `main.tf` appelle plusieurs modules pour créer et configurer des ressources Azure. Les sorties générées par ces modules fournissent des informations essentielles sur les ressources créées, permettant une gestion et une configuration efficaces de l'infrastructure.