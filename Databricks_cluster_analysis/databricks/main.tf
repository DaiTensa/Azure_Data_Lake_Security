// Initiale du prénom de l'utilisateur
variable "initial_firstname" {
  description = "Initiale du prénom"
  type        = string
}

// Nom de famille de l'utilisateur
variable "lastname" {
  description = "Nom de famille"
  type        = string
}


# Récupérer les secrets depuis terraform.tfvars
variable "sp_client_id" {
  description = "Client ID du Service Principal"
  type        = string
}

variable "sp_secret_value" {
  description = "Secret du Service Principal"
  type        = string
}

variable "sp_tenant_id" {
  description = "Tenant ID Azure"
  type        = string
}

variable "workspace_url" {
  description = "URL de Databricks Workspace"
  type        = string
}

# Configuration du provider Databricks avec les secrets du Service Principal
provider "databricks" {
  host               = var.workspace_url
  azure_client_id     = var.sp_client_id
  azure_client_secret = var.sp_secret_value
  azure_tenant_id     = var.sp_tenant_id
}


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

