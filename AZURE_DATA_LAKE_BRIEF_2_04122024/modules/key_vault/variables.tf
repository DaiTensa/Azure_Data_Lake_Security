// Nom du groupe de ressources
variable "rg_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

// Région où les ressources seront déployées
variable "location" {
  description = "Région"
  type        = string
}

// Nom du Key Vault
variable "kv_name" {
  description = "The name of the Key Vault"
  type        = string
}

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

// L'ID du compte de stockage pour définir le scope des rôles
variable "storage_account_id" {
  description = "L'ID du compte de stockage pour définir le scope des rôles"
  type        = string
}

variable "databricks_resource_group_id" {
  description = "ID du groupe de ressources Databricks"
  type        = string
}

