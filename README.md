# terraform-azurerm-postgresql-flexible-server

## Create a PostgreSQL Flexible Server in Azure
With this module you can create a PostgreSQL Flexible Server in Azure.

## Usage
For the full example see [examples/complete](examples/complete).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.65 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.65 |
| <a name="provider_random"></a> [random](#provider\_random) | >=3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_active_directory_administrator.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) | resource |
| [azurerm_postgresql_flexible_server_configuration.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_user.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_admin_users"></a> [aad\_admin\_users](#input\_aad\_admin\_users) | List of AAD users to be assigned as Administrators for PostgreSQL Flexible Server | `list(string)` | `[]` | no |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | (Optional) Administrator login to be used for PostgreSQL Flexible Server. | `string` | `null` | no |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | (Optional) Administrator password to be used for PostgreSQL Flexible Server. | `string` | `null` | no |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | Authentication configuration for PostgreSQL Flexible Server | <pre>object({<br>    active_directory_auth_enabled = optional(bool, false)<br>    password_auth_enabled         = optional(bool, true)<br>    tenant_id                     = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | (Optional) The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days. | `number` | `null` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | List of configuration objects for PostgreSQL Flexible Server | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | (Optional) Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. Defaults to false. | `bool` | `false` | no |
| <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability) | (Optional) High availability configuration for PostgreSQL Flexible Server. | <pre>object({<br>    mode                      = string<br>    standby_availability_zone = optional(number, null)<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location in which to create the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Optional) Maintenance windows configuration for PostgreSQL Flexible Server. | <pre>object({<br>    day_of_week  = optional(number, 0)<br>    start_hour   = optional(number, 0)<br>    start_minute = optional(number, 0)<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created | `string` | n/a | yes |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | (Optional) The ID of the private DNS zone to create the PostgreSQL Flexible Server. | `string` | `null` | no |
| <a name="input_psql_version"></a> [psql\_version](#input\_psql\_version) | The version of PostgreSQL Flexible Server to use. | `number` | n/a | yes |
| <a name="input_random_config"></a> [random\_config](#input\_random\_config) | (Required) Configuration for random generated strings used as db credentials | <pre>object({<br>    login_length          = number<br>    login_special         = optional(bool, false)<br>    login_min_lower       = number<br>    pass_length           = number<br>    pass_special          = optional(bool, true)<br>    pass_override_special = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern | `string` | n/a | yes |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | (Optional) The max storage allowed for the PostgreSQL Flexible Server | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Optional) The ID of the virtual network subnet to create the PostgreSQL Flexible Server | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the PostgreSQL Flexible Server. | `map(string)` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the PostgreSQL Flexible Server. |
<!-- END_TF_DOCS -->
