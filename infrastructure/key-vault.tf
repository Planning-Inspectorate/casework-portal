resource "azurerm_key_vault" "main" {
  #checkov:skip=CKV_AZURE_109: TODO: consider firewall settings, route traffic via VNet
  #checkov:skip=CKV_AZURE_189: "Ensure that Azure Key Vault disables public network access"
  #checkov:skip=CKV2_AZURE_32: "Ensure private endpoint is configured to key vault"
  name                        = "${local.org}-kv-${local.resource_suffix}"
  location                    = module.primary_region.location
  resource_group_name         = azurerm_resource_group.primary.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  rbac_authorization_enabled   = true
  sku_name                    = "standard"

  tags = local.tags
}

# secrets to be manually populated
resource "azurerm_key_vault_secret" "manual_secrets" {
  #checkov:skip=CKV_AZURE_41: expiration not valid
  for_each = toset(local.secrets)

  key_vault_id = azurerm_key_vault.main.id
  name         = each.value
  value        = "<terraform_placeholder>"
  content_type = "plaintext"

  tags = local.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

locals {
  secrets = [
    "client-secret"
  ]

  key_vault_refs = merge(
    {
      for k, v in azurerm_key_vault_secret.manual_secrets : k => "@Microsoft.KeyVault(SecretUri=${v.versionless_id})"
    },
    {
      "app-insights-connection-string" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.app_insights_connection_string.versionless_id})"
      "redis-connection-string"        = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.redis_web_connection_string.versionless_id})"
      "session-secret"                 = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.session_secret.versionless_id})"
    }
  )
}