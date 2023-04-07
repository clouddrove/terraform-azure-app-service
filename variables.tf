#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = ""
  description = "Terraform current module repo"
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "managedby" {
  type        = string
  default     = ""
  description = "ManagedBy, eg ''."
}

variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources."
  default     = true
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "A container that holds related resources for an Azure solution"

}

variable "location" {
  type        = string
  default     = null
  description = "Location where resource group will be created."
}


variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}

# APP SERVICE PLAN

variable "service_plan" {
  description = "Definition of the dedicated plan to use"
  type = object({
    kind             = string
    size             = string
    capacity         = optional(number)
    tier             = string
    per_site_scaling = optional(bool)
  })
}

variable "ips_allowed" {
  description = "IPs restriction for App Service to allow specific IP addresses or ranges"
  type        = list(string)
  default     = []
}

variable "subnet_ids_allowed" {
  description = "Allow Specific Subnets for App Service"
  type        = list(string)
  default     = []
}

# APP SERVICE

variable "app_service_name" {
  description = "Specifies the name of the App Service."
  default     = ""
}

variable "app_settings" {
  description = "A key-value pair of App Settings."
  type        = map(string)
  default     = {}
}

variable "enable_client_affinity" {
  description = "Should the App Service send session affinity cookies, which route client requests in the same session to the same instance?"
  default     = false
}

variable "enable_https" {
  description = "Can the App Service only be accessed via HTTPS?"
  default     = false
}

variable "enable_client_certificate" {
  description = "Does the App Service require client certificates for incoming requests"
  default     = false
}

variable "site_config" {
  description = "Site configuration for Application Service"
  type        = any
  default     = {}
}

variable "enable_auth_settings" {
  description = "Specifies the Authenication enabled or not"
  default     = false
}

variable "default_auth_provider" {
  description = "The default provider to use when multiple providers have been set up. Possible values are `AzureActiveDirectory`, `Facebook`, `Google`, `MicrosoftAccount` and `Twitter`"
  default     = "AzureActiveDirectory"
}

variable "unauthenticated_client_action" {
  description = "The action to take when an unauthenticated client attempts to access the app. Possible values are `AllowAnonymous` and `RedirectToLoginPage`"
  default     = "RedirectToLoginPage"
}

variable "token_store_enabled" {
  description = "If enabled the module will durably store platform-specific security tokens that are obtained during login flows"
  default     = false
}

variable "active_directory_auth_setttings" {
  description = "Acitve directory authentication provider settings for app service"
  type        = any
  default     = {}
}

variable "connection_strings" {
  description = "Connection strings for App Service"
  type        = list(map(string))
  default     = []
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned"
  default     = null
}

variable "storage_mounts" {
  description = "Storage account mount points for App Service"
  type        = list(map(string))
  default     = []
}

# Private Endpoint

variable "virtual_network_id" {
  type        = string
  default     = null
  description = "The name of the virtual network"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The resource ID of the subnet"
}

variable "enable_private_endpoint" {
  type        = bool
  default     = false
  description = "enable or disable private endpoint to storage account"
}

variable "existing_private_dns_zone" {
  type        = string
  default     = null
  description = "Name of the existing private DNS zone"
}

variable "existing_private_dns_zone_resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the existing resource group"
}

## Addon vritual link
variable "addon_vent_link" {
  type        = bool
  default     = false
  description = "The name of the addon vnet "
}

variable "addon_resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the addon vnet resource group"
}

variable "addon_virtual_network_id" {
  type        = string
  default     = ""
  description = "The name of the addon vnet link vnet id"
}

# app insights
variable "application_insights_enabled" {
  description = "Specify the Application Insights use for this App Service"
  default     = true
}

variable "application_insights_id" {
  description = "Resource ID of the existing Application Insights"
  default     = null
}

variable "app_insights_name" {
  description = "The Name of the application insights"
  default     = ""
}

variable "application_insights_type" {
  description = "Specifies the type of Application Insights to create. Valid values are `ios` for iOS, `java` for Java web, `MobileCenter` for App Center, `Node.JS` for Node.js, `other` for General, `phone` for Windows Phone, `store` for Windows Store and `web` for ASP.NET."
  default     = "web"
}

variable "retention_in_days" {
  description = "Specifies the retention period in days. Possible values are `30`, `60`, `90`, `120`, `180`, `270`, `365`, `550` or `730`"
  default     = 90
}

variable "disable_ip_masking" {
  description = "By default the real client ip is masked as `0.0.0.0` in the logs. Use this argument to disable masking and log the real client ip"
  default     = false
}

variable "enable_vnet_integration" {
  description = "Manages an App Service Virtual Network Association"
  default     = false
}

variable "integration_subnet_id" {
  type        = string
  default     = null
  description = "The resource ID of the subnet"
}