variable "subscription_id" {
  description = "ID de l'abonnement Azure où les ressources seront créées"
  type        = string
}

variable "rg_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "rg_location" {
  description = "Région du groupe de ressources"
  type        = string
}

variable "kv_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "storage_account" {
  description = "Nom du compte de stockage"
  type        = string
}

variable "initial_firstname" {

  description = "The initial firstname for the Key Vault"

  type        = string

}

variable "lastname" {

  description = "The lastname for the key vault"

  type        = string

}