resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.org}-log-${local.resource_suffix}"
  location            = module.primary_region.location
  resource_group_name = azurerm_resource_group.primary.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.1

  tags = local.tags
}

resource "azurerm_application_insights" "main" {
  name                 = "${local.org}-ai-${local.resource_suffix}"
  location             = module.primary_region.location
  resource_group_name  = azurerm_resource_group.primary.name
  workspace_id         = azurerm_log_analytics_workspace.main.id
  application_type     = "web" # should this be Node.JS, or general?
  daily_data_cap_in_gb = 0.1

  tags = local.tags
}

resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  #checkov:skip=CKV_AZURE_41: expiration not valid
  key_vault_id = azurerm_key_vault.main.id
  name         = "app-insights-connection-string"
  value        = azurerm_application_insights.main.connection_string
  content_type = "connection-string"

  tags = local.tags
}

resource "azurerm_monitor_action_group" "tech" {
  name                = "pins-ag-${local.service_name}-tech-${var.environment}"
  resource_group_name = azurerm_resource_group.primary.name
  short_name          = "CaseworkP"
  tags                = local.tags

  # we set emails in the action groups in Azure Portal - to avoid needing to manage emails in terraform
  lifecycle {
    ignore_changes = [
      email_receiver
    ]
  }
}

resource "azurerm_monitor_action_group" "service_manager" {
  name                = "pins-ag-${local.service_name}-service-manager-${var.environment}"
  resource_group_name = azurerm_resource_group.primary.name
  short_name          = "CaseworkP"
  tags                = local.tags

  # we set emails in the action groups in Azure Portal - to avoid needing to manage emails in terraform
  lifecycle {
    ignore_changes = [
      email_receiver
    ]
  }
}

locals {
  action_group_ids = {
    tech            = azurerm_monitor_action_group.tech.id
    service_manager = azurerm_monitor_action_group.service_manager.id
    iap             = data.azurerm_monitor_action_group.common["iap"].id,
    its             = data.azurerm_monitor_action_group.common["its"].id,
    info_sec        = data.azurerm_monitor_action_group.common["info_sec"].id
  }
}