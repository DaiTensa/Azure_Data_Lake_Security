# Configuration du Cluster Databricks

La configuration et le déploiement d'un cluster Databricks via Terraform.

## Structure du Code

Le code est organisé dans le dossier `Databricks_cluster_analysis/databricks/` et contient la configuration nécessaire pour déployer un cluster Databricks avec des paramètres spécifiques.

## Variables Requises

Les variables suivantes doivent être définies dans votre fichier `terraform.tfvars` :

```terraform
// filepath: terraform.tfvars
sp_client_id     = "votre_client_id"
sp_secret_value  = "votre_secret"
sp_tenant_id     = "votre_tenant_id"
workspace_url    = "votre_workspace_url"
initial_firstname = "v"
lastname         = "nom"
```

| Variable | Description | Type |
|----------|-------------|------|
| `sp_client_id` | ID du Service Principal Azure | string |
| `sp_secret_value` | Clé secrète du Service Principal | string |
| `sp_tenant_id` | ID du tenant Azure | string |
| `workspace_url` | URL du workspace Databricks | string |
| `initial_firstname` | Initiale du prénom | string |
| `lastname` | Nom de famille | string |

## Configuration du Provider

Le provider Databricks est configuré avec l'authentification Azure AD :

```terraform
provider "databricks" {
  host               = var.workspace_url
  azure_client_id     = var.sp_client_id
  azure_client_secret = var.sp_secret_value
  azure_tenant_id     = var.sp_tenant_id
}
```

## Spécifications du Cluster

Le cluster est configuré avec les paramètres suivants :

```terraform
resource "databricks_cluster" "cluster" {
  cluster_name            = "databricks-cluster-${var.initial_firstname}${var.lastname}"
  spark_version           = "15.4.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 60
  spark_conf = {
    "spark.databricks.cluster.profile" = "singleUser"
  }
  num_workers = 1
}
```

### Paramètres du Cluster

- **Nom** : Le nom du cluster est généré automatiquement avec l'initiale du prénom et le nom de famille
- **Version Spark** : 15.4.x avec Scala 2.12
- **Type de Node** : Standard_DS3_v2
- **Auto-termination** : 60 minutes
- **Nombre de Workers** : 1
- **Profil** : singleUser

## Déploiement

Pour déployer le cluster, exécutez les commandes suivantes :

```bash
terraform init
terraform plan -var-file="terraform.tfvars" -out="plan.tfplan"
terraform apply "plan.tfplan"
```