# Appel des modules
module "resource_group" {
  source      = "./modules/resource_group"
  rg_name     = var.rg_name
  rg_location = var.rg_location
}

module "data_lake" {
  source           = "./modules/data_lake"
  rg_name          = module.resource_group.rg_name
  storage_account  = var.storage_account
  location         = module.resource_group.rg_location
  container_names  = ["rawdata", "transformeddata", "aggregateddata"]
}

module "databricks" {
  source           = "./modules/databricks"
  subscription_id    = var.subscription_id
  rg_name          = module.resource_group.rg_name
  location         = module.resource_group.rg_location
  initial_firstname = var.initial_firstname
  lastname         = var.lastname
  key_vault_id     = module.key_vault.key_vault_id

  providers = {
    databricks = databricks
  }
}


module "key_vault" {
  source           = "./modules/key_vault"
  rg_name          = module.resource_group.rg_name
  kv_name          = var.kv_name
  location         = module.resource_group.rg_location
  initial_firstname = var.initial_firstname
  lastname         = var.lastname
  storage_account_id  = module.data_lake.storage_account_id
  databricks_resource_group_id  = module.databricks.databricks_resource_group_id
}


module "monitoring" {
  source      = "./modules/monitoring"
  rg_name     = module.resource_group.rg_name
  location    = module.resource_group.rg_location
}


