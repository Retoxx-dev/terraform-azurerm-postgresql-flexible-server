provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-terraform-northeu-001"
  location = "northeurope"
}

module "virtual-network" {
  source  = "Retoxx-dev/virtual-network/azurerm"
  version = "1.0.2"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = "vnet-terraform-northeu-001"
  address_space = ["10.0.0.0/16"]

  subnets = [
    {
      name             = "snet-terraform-northeu-postgres"
      address_prefixes = ["10.0.255.224/27"]
      subnet_delegations = [
        {
          name         = "PostgreSQLDelegation"
          service_name = "Microsoft.DBforPostgreSQL/flexibleServers"
          service_actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      ]
    }
  ]
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "vdn-psql-terraform-northeu-001"
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = module.virtual-network.id
}

module "postgresql-flexible-server" {
  source  = "Retoxx-dev/postgresql-flexible-server/azurerm"
  version = "1.0.0"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  random_config = {
    login_length          = 16
    login_min_lower       = 8
    pass_length           = 24
    pass_override_special = "!#$%&*()-_=+[]{}<>:?"
  }

  name                = "psql-terraform-northeu-001"
  psql_version        = 14
  subnet_id           = module.virtual-network.subnet_ids["snet-terraform-northeu-postgres"]
  private_dns_zone_id = azurerm_private_dns_zone.this.id
  sku_name            = "B_Standard_B1ms"
  storage_mb          = "32768"

  authentication = {
    active_directory_auth_enabled = true
  }

  aad_admin_users = ["user1@example.com", "user2@example.com"]

  configuration = [
    {
      name  = "azure.extensions"
      value = "TIMESCALEDB"
    },
    {
      name  = "shared_preload_libraries"
      value = "timescaledb"
    },
    {
      name  = "max_connections"
      value = "80"
    }
  ]

  tags = {
    "Environment" = "Production"
  }
}