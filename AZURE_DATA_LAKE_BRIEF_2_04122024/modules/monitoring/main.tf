resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "loganalytics-dten"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "alerts-dten"
  resource_group_name = var.rg_name
  short_name          = "alerts"

  email_receiver {
    name          = "Dai"
    email_address = "dai.tensaout@gmail.com"
  }
}
