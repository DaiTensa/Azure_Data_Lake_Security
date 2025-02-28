
resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks-${var.initial_firstname}${var.lastname}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "standard"

  managed_resource_group_name = "databricks-rg-${var.initial_firstname}-${var.lastname}"
}
