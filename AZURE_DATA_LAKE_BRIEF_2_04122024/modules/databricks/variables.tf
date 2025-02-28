variable "rg_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région"
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

variable "key_vault_id" {
  description = "ID du Key Vault"
  type        = string
}

variable "subscription_id" {
  description = "L'ID de la souscription Azure"
  type        = string
}



