module "app_portal" {
  #checkov:skip=CKV_TF_1: Use of commit hash are not required for our Terraform modules
  source = "github.com/Planning-Inspectorate/infrastructure-modules.git//modules/node-app-service?ref=1.56"

  resource_group_name = azurerm_resource_group.primary.name
  location            = module.primary_region.location

  # naming
  app_name        = "web"
  resource_suffix = var.environment
  service_name    = local.service_name
  tags            = local.tags

  # service plan & scaling
  app_service_plan_id                  = azurerm_service_plan.apps.id
  app_service_plan_resource_group_name = azurerm_resource_group.primary.name
  worker_count                         = var.apps_config.app_service_plan.worker_count # match the app service plan

  # container
  container_registry_name = var.tooling_config.container_registry_name
  container_registry_rg   = var.tooling_config.container_registry_rg
  image_name              = "casework-portal/web"

  # networking
  app_service_private_dns_zone_id = data.azurerm_private_dns_zone.app_service.id
  inbound_vnet_connectivity       = true
  integration_subnet_id           = azurerm_subnet.apps.id
  endpoint_subnet_id              = azurerm_subnet.main.id
  outbound_vnet_connectivity      = true
  # public access via Front Door
  front_door_restriction = true
  public_network_access  = true

  # monitoring
  log_analytics_workspace_id        = azurerm_log_analytics_workspace.main.id
  monitoring_alerts_enabled         = false
  action_group_ids                  = local.action_group_ids
  health_check_path                 = "/health"
  health_check_eviction_time_in_min = 10

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING      = local.key_vault_refs["app-insights-connection-string"]
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"

    NODE_ENV    = var.apps_config.node_environment
    ENVIRONMENT = var.environment

    #auth
    AUTH_CLIENT_ID     = var.apps_config.auth.client_id
    AUTH_CLIENT_SECRET = local.key_vault_refs["client-secret"]
    AUTH_TENANT_ID     = data.azurerm_client_config.current.tenant_id
    APP_HOSTNAME       = var.web_domains.portal

    # logging
    LOG_LEVEL = var.apps_config.logging.level

    # sessions
    REDIS_CONNECTION_STRING = local.key_vault_refs["redis-connection-string"]
    SESSION_SECRET          = local.key_vault_refs["session-secret"]
  }

  providers = {
    azurerm         = azurerm
    azurerm.tooling = azurerm.tooling
  }
}

## RBAC for secrets
resource "azurerm_role_assignment" "app_web_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_portal.principal_id
}

## RBAC for secrets (staging slot)
resource "azurerm_role_assignment" "app_web_staging_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_portal.staging_principal_id
}

## sessions
resource "random_password" "session_secret" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "session_secret" {
  #checkov:skip=CKV_AZURE_41: TODO: Secret rotation
  key_vault_id = azurerm_key_vault.main.id
  name         = "session-secret"
  value        = random_password.session_secret.result
  content_type = "session-secret"

  depends_on = [
    azurerm_private_endpoint.keyvault,
    azurerm_private_dns_zone_virtual_network_link.keyvault
  ]

  tags = local.tags
}
