#################################################################
# GENERAL
#################################################################
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Kubernetes Cluster."
}

variable "location" {
  type        = string
  description = "(Required) The location in which to create the Kubernetes Cluster."
}

#################################################################
# RANDOMS
#################################################################
variable "random_config" {
  type = object({
    login_length          = number
    login_special         = optional(bool, false)
    login_min_lower       = number
    pass_length           = number
    pass_special          = optional(bool, true)
    pass_override_special = optional(string, null)
  })
  description = "(Required) Configuration for random generated strings used as db credentials"
}

#################################################################
# POSTGRESQL FLEXIBLE SERVER
#################################################################
variable "name" {
  type        = string
  description = "(Required) The name which should be used for this PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created"
}

variable "psql_version" {
  type        = number
  description = "The version of PostgreSQL Flexible Server to use."
}

variable "subnet_id" {
  type        = string
  description = "(Optional) The ID of the virtual network subnet to create the PostgreSQL Flexible Server"
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "(Optional) The ID of the private DNS zone to create the PostgreSQL Flexible Server."
  default     = null
}

variable "administrator_login" {
  type        = string
  description = "(Optional) Administrator login to be used for PostgreSQL Flexible Server."
  default     = null
}

variable "administrator_password" {
  type        = string
  description = "(Optional) Administrator password to be used for PostgreSQL Flexible Server."
  default     = null
}

variable "authentication" {
  type = object({
    active_directory_auth_enabled = optional(bool, false)
    password_auth_enabled         = optional(bool, true)
    tenant_id                     = optional(string, null)
  })
  description = "Authentication configuration for PostgreSQL Flexible Server"
  default     = null
}

variable "backup_retention_days" {
  type        = number
  description = "(Optional) The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days."
  default     = null
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. Defaults to false."
  default     = false
}

variable "high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = optional(number, null)
  })
  description = "(Optional) High availability configuration for PostgreSQL Flexible Server."
  default     = null
}

variable "maintenance_window" {
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  description = "(Optional) Maintenance windows configuration for PostgreSQL Flexible Server."
  default     = null
}

variable "sku_name" {
  type        = string
  description = "(Required) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern"
}

variable "storage_mb" {
  type        = string
  description = "(Optional) The max storage allowed for the PostgreSQL Flexible Server"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to the PostgreSQL Flexible Server."
  default     = null
}

variable "zone" {
  type        = number
  description = "(Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located."
  default     = null
}

#################################################################
# POSTGRESQL AZURE ACTIVE DIRECTORY ADMINS
#################################################################
variable "aad_admin_users" {
  type        = list(string)
  description = "List of AAD users to be assigned as Administrators for PostgreSQL Flexible Server"
  default     = []
}

#################################################################
# POSTGRESQL EXTENSIONS
#################################################################
variable "configuration" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of configuration objects for PostgreSQL Flexible Server"
  default     = null
}
