output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.databricks.workspace_url
}

output "databricks_resource_group_id" {
  value = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_databricks_workspace.databricks.managed_resource_group_name}"
}
