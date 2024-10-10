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
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

# variable "app_service_linux" {
#   type        = bool
#   description = "Set to false to prevent the module from creating any linux web app resources."
#   default     = false
# }

# variable "app_service_linux_container" {
#   type        = bool
#   description = "Set to false to prevent the module from creating any linux web app resources."
#   default     = false
# }

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


# variable "tags" {
#   type        = map(string)
#   default     = {}
#   description = "A map of tags to add to all resources"
# }

# APP SERVICE PLAN

variable "os_type" {
  type        = string
  description = "The O/S type for the App Services to be hosted in this plan. Possible values include `Windows`, `Linux`, and `WindowsContainer`."

  validation {
    condition     = try(contains(["Windows", "Linux", "WindowsContainer"], var.os_type), true)
    error_message = "The `os_type` value must be valid. Possible values are `Windows`, `Linux`, and `WindowsContainer`."
  }
}

variable "sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."

  validation {
    condition     = try(contains(["B1", "B2", "B3", "D1", "F1", "FREE", "I1", "I2", "I3", "I1v2", "I2v2", "I3v2", "P1v2", "P2v2", "P3v2", "P1v3", "P2v3", "P3v3", "S1", "S2", "S3", "SHARED", "Y1", "EP1", "EP2", "EP3", "WS1", "WS2", "WS3"], var.sku_name), true)
    error_message = "The `sku_name` value must be valid. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3."
  }
}

variable "app_service_environment_id" {
  type        = string
  default     = null
  description = "The ID of the App Service Environment to create this Service Plan in. Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm_app_service_environment, or I1v2, I2v2, I3v2 for azurerm_app_service_environment_v3"
}

variable "worker_count" {
  type        = number
  default     = 1
  description = "The number of Workers (instances) to be allocated."
}

variable "maximum_elastic_worker_count" {
  type        = number
  default     = null
  description = "The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU."
}

variable "per_site_scaling_enabled" {
  type        = bool
  default     = false
  description = "Should Per Site Scaling be enabled."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether enable public access for the App Service."
}

variable "app_service_vnet_integration_subnet_id" {
  type        = string
  default     = null
  description = "Id of the subnet to associate with the app service"
}

variable "site_config" {
  type        = any
  default     = {}
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block."
}

variable "authorized_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
}

variable "ip_restriction_headers" {
  type        = map(list(string))
  default     = null
  description = "IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers"
}

variable "authorized_ips" {
  type        = list(string)
  default     = []
  description = "IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
}

variable "authorized_service_tags" {
  type        = list(string)
  default     = []
  description = "Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
}

variable "scm_authorized_subnet_ids" {
  type        = list(string)
  default     = []
  description = "SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
}

variable "scm_ip_restriction_headers" {
  type        = map(list(string))
  default     = null
  description = "IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers"
}

variable "scm_authorized_ips" {
  type        = list(string)
  default     = []
  description = "SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
}

variable "scm_authorized_service_tags" {
  type        = list(string)
  default     = []
  description = "SCM Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction"
}

variable "staging_slot_custom_app_settings" {
  type        = map(string)
  default     = null
  description = "Override staging slot with custom app settings"
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

variable "dotnet_version" {
  type        = string
  default     = null
  description = "dotnet version"
}

variable "java_server" {
  type        = string
  default     = null
  description = "Java server"
}

variable "java_server_version" {
  type        = string
  default     = null
  description = "Java server version"
}

variable "java_version" {
  type        = string
  default     = null
  description = "Java version"
}

variable "node_version" {
  type        = string
  default     = null
  description = "Node version"
}

variable "php_version" {
  type        = string
  default     = null
  description = "php version"
}

variable "python_version" {
  type        = string
  default     = null
  description = "Python version"
}

variable "ruby_version" {
  type        = string
  default     = null
  description = "Ruby version"
}

variable "application_insights_enabled" {
  type        = bool
  default     = true
  description = "Use Application Insights for this App Service"
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings"
}

variable "connection_strings" {
  type        = list(map(string))
  default     = []
  description = "Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string"
}

variable "auth_settings" {
  type        = any
  default     = {}
  description = "Authentication settings. Issuer URL is generated thanks to the tenant ID. For active_directory block, the allowed_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings"
}

variable "auth_settings_v2" {
  type        = any
  default     = {}
  description = "Authentication settings V2. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2"
}

variable "client_affinity_enabled" {
  type        = bool
  default     = false
  description = "Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled"
}

variable "https_only" {
  type        = bool
  default     = false
  description = "HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only"
}

variable "mount_points" {
  type        = list(map(string))
  default     = []
  description = "Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account"
}

variable "app_service_logs" {
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
  default     = null
  description = "Configuration of the App Service and App Service Slot logs. Documentation [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs)"
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
  description = "Map with identity block information."
}

variable "application_insights_id" {
  type        = string
  default     = null
  description = "ID of the existing Application Insights to use instead of deploying a new one."
}

variable "application_insights_type" {
  type        = string
  default     = "web"
  description = "Application type for Application Insights resource"
}

variable "application_insights_sampling_percentage" {
  type        = number
  default     = null
  description = "Specifies the percentage of sampled datas for Application Insights. Documentation [here](https://docs.microsoft.com/en-us/azure/azure-monitor/app/sampling#ingestion-sampling)"
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

# variable "is_linux_webapp" {
#   description = "Enable linux web app"
#   type        = bool
#   default     = true
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

variable "retention_in_days" {
  type        = number
  default     = 90
  description = "Specifies the retention period in days. Possible values are `30`, `60`, `90`, `120`, `180`, `270`, `365`, `550` or `730`"
}

variable "disable_ip_masking" {
  type        = bool
  default     = false
  description = "By default the real client ip is masked as `0.0.0.0` in the logs. Use this argument to disable masking and log the real client ip"
}

variable "enable_vnet_integration" {
  type        = bool
  default     = false
  description = "Manages an App Service Virtual Network Association"
}

variable "integration_subnet_id" {
  type        = string
  default     = null
  description = "The resource ID of the subnet"
}

variable "app_insights_workspace_id" {
  type        = string
  default     = null
  description = "Application insights workspace id"
}

variable "read_permissions" {
  type        = list(string)
  default     = ["aggregate", "api", "draft", "extendqueries", "search"]
  description = "Read permissions for telemetry"
}

variable "use_docker" {
  type        = bool
  default     = false
  description = "Variable to use container as runtime"
}

variable "use_dotnet" {
  type        = bool
  default     = false
  description = "Variable to use dotnet as runtime"
}

variable "use_php" {
  type        = bool
  default     = false
  description = "Variable to use php as runtime"
}

variable "use_python" {
  type        = bool
  default     = false
  description = "Variable to use python as runtime"
}

variable "use_node" {
  type        = bool
  default     = false
  description = "Variable to use node as runtime"
}

variable "use_java" {
  type        = bool
  default     = false
  description = "Variable to use java as runtime"
}

variable "use_ruby" {
  type        = bool
  default     = false
  description = "Variable to use ruby as runtime"
}

variable "use_current_stack" {
  type        = bool
  default     = true
  description = "Variable for current stack for windows web app ( Possible values -> dotnet, dotnetcore, node, python, php, and java )"
}

variable "current_stack" {
  type        = string
  default     = null
  description = "Specify runtime stack here"
}

variable "java_embedded_server_enabled" {
  type        = string
  default     = null
  description = "Java server"
}

variable "use_tomcat" {
  type        = bool
  default     = false
  description = "Variable to use tomcat as runtime"
}

variable "tomcat_version" {
  type        = string
  default     = null
  description = "tomcat version"
}

variable "dotnet_core_version" {
  type        = string
  default     = null
  description = "dotnet version"
}

variable "use_go" {
  type        = bool
  default     = false
  description = "Variable to use GO as runtime"
}

variable "go_version" {
  type        = string
  default     = null
  description = "Go version"
}