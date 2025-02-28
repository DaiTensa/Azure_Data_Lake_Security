variable "rg_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région"
  type        = string
}

variable "storage_account" {
  description = "Nom du compte de stockage"
  type        = string
}

variable "container_names" {
  description = "Liste des noms des conteneurs à créer dans le Data Lake"
  type        = list(string)
  default     = ["rawdata", "transformeddata", "aggregateddata"]
}