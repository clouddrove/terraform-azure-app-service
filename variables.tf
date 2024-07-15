#Module      : LABEL
#Description : Terraform label module variables.

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
  default     = ["name", "environment", ]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "managedby" {
  type        = string
  default     = ""
  description = "ManagedBy, eg ''."
}

variable "enable" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources."
  default     = true
}

variable "app_service_linux" {
  type        = bool
  description = "Set to false to prevent the module from creating any linux web app resources."
  default     = false
}

variable "app_service_linux_container" {
  type        = bool
  description = "Set to false to prevent the module from creating any linux web app resources."
  default     = false
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

variable "os_type" {
  description = "The O/S type for the App Services to be hosted in this plan. Possible values include `Windows`, `Linux`, and `WindowsContainer`."
  type        = string

  validation {
    condition     = try(contains(["Windows", "Linux", "WindowsContainer"], var.os_type), true)
    error_message = "The `os_type` value must be valid. Possible values are `Windows`, `Linux`, and `WindowsContainer`."
  }
}

variable "sku_name" {
  description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."
  type        = string

  validation {
    condition     = try(contains(["B1", "B2", "B3", "D1", "F1", "FREE", "I1", "I2", "I3", "I1v2", "I2v2", "I3v2", "P1v2", "P2v2", "P3v2", "P1v3", "P2v3", "P3v3", "S1", "S2", "S3", "SHARED", "Y1", "EP1", "EP2", "EP3", "WS1", "WS2", "WS3"], var.sku_name), true)
    error_message = "The `sku_name` value must be valid. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."
  }
}

variable "app_service_environment_id" {
  description = "The ID of the App Service Environment to create this Service Plan in. Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm_app_service_environment, or I1v2, I2v2, I3v2 for azurerm_app_service_environment_v3"
  type        = string
  default     = null
}

variable "worker_count" {
  description = "The number of Workers (instances) to be allocated."
  type        = number
  default     = 1
}

variable "maximum_elastic_worker_count" {
  description = "The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU."
  type        = number
  default     = null
}

variable "per_site_scaling_enabled" {
  description = "Should Per Site Scaling be enabled."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether enable public access for the App Service."
  type        = bool
  default     = true
}

variable "app_service_vnet_integration_subnet_id" {
  description = "Id of the subnet to associate with the app service"
  type        = string
  default     = null
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block."
  type        = any
  default     = {}
}

variable "authorized_subnet_ids" {
  description = "Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "ip_restriction_headers" {
  description = "IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers"
  type        = map(list(string))
  default     = null
}

variable "authorized_ips" {
  description = "IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "authorized_service_tags" {
  description = "Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_subnet_ids" {
  description = "SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_ip_restriction_headers" {
  description = "IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers"
  type        = map(list(string))
  default     = null
}

variable "scm_authorized_ips" {
  description = "SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_service_tags" {
  description = "SCM Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "staging_slot_custom_app_settings" {
  type        = map(string)
  description = "Override staging slot with custom app settings"
  default     = null
}

variable "docker_image_name" {
  type        = string
  default     = ""
  description = "The docker image, including tag, to be used. e.g. appsvc/staticsite:latest."
}

variable "docker_registry_url" {
  type        = string
  default     = ""
  description = "The URL of the container registry where the docker_image_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com. This value is required with docker_image_name"
}

variable "docker_registry_username" {
  type        = string
  default     = null
  description = "The User Name to use for authentication against the registry to pull the image."
}

variable "docker_registry_password" {
  type        = string
  default     = null
  description = "The User Name to use for authentication against the registry to pull the image."
}

variable "application_insights_enabled" {
  description = "Use Application Insights for this App Service"
  type        = bool
  default     = true
}

variable "app_settings" {
  description = "Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings"
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  description = "Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string"
  type        = list(map(string))
  default     = []
}

variable "auth_settings" {
  description = "Authentication settings. Issuer URL is generated thanks to the tenant ID. For active_directory block, the allowed_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings"
  type        = any
  default     = {}
}

variable "auth_settings_v2" {
  description = "Authentication settings V2. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2"
  type        = any
  default     = {}
}

variable "client_affinity_enabled" {
  description = "Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled"
  type        = bool
  default     = false
}

variable "https_only" {
  description = "HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only"
  type        = bool
  default     = false
}

variable "mount_points" {
  description = "Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account"
  type        = list(map(string))
  default     = []
}

variable "app_service_logs" {
  description = "Configuration of the App Service and App Service Slot logs. Documentation [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs)"
  type = object({
    detailed_error_messages = optional(bool)
    failed_request_tracing  = optional(bool)
    application_logs = optional(object({
      file_system_level = string
      azure_blob_storage = optional(object({
        level             = string
        retention_in_days = number
        sas_url           = string
      }))
    }))
    http_logs = optional(object({
      azure_blob_storage = optional(object({
        retention_in_days = number
        sas_url           = string
      }))
      file_system = optional(object({
        retention_in_days = number
        retention_in_mb   = number
      }))
    }))
  })
  default = null
}

variable "identity" {
  description = "Map with identity block information."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

variable "application_insights_id" {
  description = "ID of the existing Application Insights to use instead of deploying a new one."
  type        = string
  default     = null
}

variable "application_insights_type" {
  description = "Application type for Application Insights resource"
  type        = string
  default     = "web"
}

variable "application_insights_sampling_percentage" {
  description = "Specifies the percentage of sampled datas for Application Insights. Documentation [here](https://docs.microsoft.com/en-us/azure/azure-monitor/app/sampling#ingestion-sampling)"
  type        = number
  default     = null
}

variable "acr_id" {
  type        = string
  default     = null
  description = "Container registry id to give access to pull images"
}

variable "enable_diagnostic" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Log Analytics workspace id in which logs should be retained."
}

variable "metric_enabled" {
  type        = bool
  default     = true
  description = "Whether metric diagnonsis should be enable in diagnostic settings for flexible Mysql."
}

variable "log_category" {
  type        = list(string)
  default     = ["AppServiceHTTPLogs", "AppServiceConsoleLogs", "AppServiceAuditLogs", "AppServiceAppLogs", "AppServicePlatformLogs"]
  description = "Categories of logs to be recorded in diagnostic setting."
}

variable "log_analytics_destination_type" {
  type        = string
  default     = null
  description = "Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "Storage account id to pass it to destination details of diagnosys setting of NSG."
}

variable "eventhub_name" {
  type        = string
  default     = null
  description = "Eventhub Name to pass it to destination details of diagnosys setting of NSG."
}

variable "eventhub_authorization_rule_id" {
  type        = string
  default     = null
  description = "Eventhub authorization rule id to pass it to destination details of diagnosys setting of NSG."
}

#------------- Web app ---------------------#

variable "is_linux_webapp" {
  description = "Enable linux web app"
  type        = bool
  default     = true
}


# variable "name" {
#   type        = string
#   default     = ""
#   description = "Name  (e.g. `app` or `cluster`)."
# }

# variable "environment" {
#   type        = string
#   default     = ""
#   description = "Environment (e.g. `prod`, `dev`, `staging`)."
# }

# variable "repository" {
#   type        = string
#   default     = ""
#   description = "Terraform current module repo"
# }

# variable "label_order" {
#   type        = list(any)
#   default     = []
#   description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
# }

# variable "managedby" {
#   type        = string
#   default     = ""
#   description = "ManagedBy, eg ''."
# }

# variable "enabled" {
#   type        = bool
#   description = "Set to false to prevent the module from creating any resources."
#   default     = true
# }

# variable "resource_group_name" {
#   type        = string
#   default     = ""
#   description = "A container that holds related resources for an Azure solution"

# }

# variable "location" {
#   type        = string
#   default     = null
#   description = "Location where resource group will be created."
# }


# variable "tags" {
#   type        = map(string)
#   default     = {}
#   description = "A map of tags to add to all resources"
# }

# # APP SERVICE PLAN

# variable "os_type" {
#   description = "The O/S type for the App Services to be hosted in this plan. Possible values include `Windows`, `Linux`, and `WindowsContainer`."
#   type        = string

#   validation {
#     condition     = try(contains(["Windows", "Linux", "WindowsContainer"], var.os_type), true)
#     error_message = "The `os_type` value must be valid. Possible values are `Windows`, `Linux`, and `WindowsContainer`."
#   }
# }

# variable "sku_name" {
#   description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."
#   type        = string

#   validation {
#     condition     = try(contains(["B1", "B2", "B3", "D1", "F1", "FREE", "I1", "I2", "I3", "I1v2", "I2v2", "I3v2", "P1v2", "P2v2", "P3v2", "P1v3", "P2v3", "P3v3", "S1", "S2", "S3", "SHARED", "Y1", "EP1", "EP2", "EP3", "WS1", "WS2", "WS3"], var.sku_name), true)
#     error_message = "The `sku_name` value must be valid. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."
#   }
# }

# variable "service_plan" {
#   description = "Definition of the dedicated plan to use"
#   type = object({
#     kind             = string
#     size             = string
#     capacity         = optional(number)
#     tier             = string
#     per_site_scaling = optional(bool)
#   })
# }

# variable "ips_allowed" {
#   description = "IPs restriction for App Service to allow specific IP addresses or ranges"
#   type        = list(string)
#   default     = []
# }

# variable "subnet_ids_allowed" {
#   description = "Allow Specific Subnets for App Service"
#   type        = list(string)
#   default     = []
# }

# # APP SERVICE

# variable "app_service_name" {
#   description = "Specifies the name of the App Service."
#   default     = ""
# }

# variable "app_settings" {
#   description = "A key-value pair of App Settings."
#   type        = map(string)
#   default     = {}
# }

# variable "enable_client_affinity" {
#   description = "Should the App Service send session affinity cookies, which route client requests in the same session to the same instance?"
#   default     = false
# }

# variable "enable_https" {
#   description = "Can the App Service only be accessed via HTTPS?"
#   default     = false
# }

# variable "enable_client_certificate" {
#   description = "Does the App Service require client certificates for incoming requests"
#   default     = false
# }

# variable "site_config" {
#   description = "Site configuration for Application Service"
#   type        = any
#   default     = {}
# }

# variable "enable_auth_settings" {
#   description = "Specifies the Authenication enabled or not"
#   default     = false
# }

# variable "default_auth_provider" {
#   description = "The default provider to use when multiple providers have been set up. Possible values are `AzureActiveDirectory`, `Facebook`, `Google`, `MicrosoftAccount` and `Twitter`"
#   default     = "AzureActiveDirectory"
# }

# variable "unauthenticated_client_action" {
#   description = "The action to take when an unauthenticated client attempts to access the app. Possible values are `AllowAnonymous` and `RedirectToLoginPage`"
#   default     = "RedirectToLoginPage"
# }

# variable "token_store_enabled" {
#   description = "If enabled the module will durably store platform-specific security tokens that are obtained during login flows"
#   default     = false
# }

# variable "active_directory_auth_setttings" {
#   description = "Acitve directory authentication provider settings for app service"
#   type        = any
#   default     = {}
# }

# variable "connection_strings" {
#   description = "Connection strings for App Service"
#   type        = list(map(string))
#   default     = []
# }

# variable "identity_ids" {
#   description = "Specifies a list of user managed identity ids to be assigned"
#   default     = null
# }

# variable "storage_mounts" {
#   description = "Storage account mount points for App Service"
#   type        = list(map(string))
#   default     = []
# }

# # Private Endpoint

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

# ## Addon vritual link
# variable "addon_vent_link" {
#   type        = bool
#   default     = false
#   description = "The name of the addon vnet "
# }

# variable "addon_resource_group_name" {
#   type        = string
#   default     = ""
#   description = "The name of the addon vnet resource group"
# }

# variable "addon_virtual_network_id" {
#   type        = string
#   default     = ""
#   description = "The name of the addon vnet link vnet id"
# }

# # app insights
# variable "application_insights_enabled" {
#   description = "Specify the Application Insights use for this App Service"
#   default     = true
# }

# variable "application_insights_id" {
#   description = "Resource ID of the existing Application Insights"
#   default     = null
# }

# variable "app_insights_name" {
#   description = "The Name of the application insights"
#   default     = ""
# }

# variable "application_insights_type" {
#   description = "Specifies the type of Application Insights to create. Valid values are `ios` for iOS, `java` for Java web, `MobileCenter` for App Center, `Node.JS` for Node.js, `other` for General, `phone` for Windows Phone, `store` for Windows Store and `web` for ASP.NET."
#   default     = "web"
# }

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

variable "app_insights_workspace_id" {
  type    = string
  default = null
}

variable "read_permissions" {
  type    = list(string)
  default = ["aggregate", "api", "draft", "extendqueries", "search"]
}