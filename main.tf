#################################################################
# RANDOMS
#################################################################
resource "random_string" "this" {
  length    = var.random_config.login_length
  special   = var.random_config.login_special
  min_lower = var.random_config.login_min_lower
}

resource "random_password" "this" {
  length           = var.random_config.pass_length
  special          = var.random_config.pass_special
  override_special = var.random_config.pass_override_special
}

#################################################################
# POSTGRESQL FLEXIBLE SERVER
#################################################################
resource "azurerm_postgresql_flexible_server" "this" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name                   = var.name
  version                = var.psql_version
  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = var.private_dns_zone_id
  administrator_login    = var.administrator_login == null ? random_string.this.result : var.administrator_login
  administrator_password = var.administrator_password == null ? random_password.this.result : var.administrator_password


  dynamic "authentication" {
    for_each = var.authentication != null ? [var.authentication] : []
    content {
      active_directory_auth_enabled = authentication.value.active_directory_auth_enabled
      password_auth_enabled         = authentication.value.password_auth_enabled
      tenant_id                     = authentication.value.tenant_id == null ? data.azurerm_client_config.current.tenant_id : authentication.value.tenant_id
    }
  }

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  dynamic "high_availability" {
    for_each = var.high_availability != null ? [var.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  tags       = var.tags
  zone       = var.zone
}

#################################################################
# POSTGRESQL AZURE ACTIVE DIRECTORY ADMINS
#################################################################
data "azurerm_client_config" "current" {}

data "azuread_user" "this" {
  for_each = { for mail in var.aad_admin_users : mail => mail if var.aad_admin_users != [] }
  mail     = each.value
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "this" {
  for_each            = { for mail in var.aad_admin_users : mail => mail if var.aad_admin_users != [] }
  server_name         = azurerm_postgresql_flexible_server.this.name
  resource_group_name = azurerm_postgresql_flexible_server.this.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azuread_user.this[each.key].object_id
  principal_name      = data.azuread_user.this[each.key].user_principal_name
  principal_type      = "User"
}

#################################################################
# POSTGRESQL EXTENSIONS
#################################################################
resource "azurerm_postgresql_flexible_server_configuration" "this" {
  for_each  = { for configuration in var.configuration : configuration.name => configuration if var.configuration != null }
  name      = each.value.name #"azure.extensions"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = each.value.value #"CUBE,CITEXT,BTREE_GIST"
}
