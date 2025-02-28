resource "azurerm_storage_account" "adls" {
  name                     = var.storage_account
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  is_hns_enabled = "true"
}

resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.container_names)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

