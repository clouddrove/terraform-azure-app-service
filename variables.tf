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