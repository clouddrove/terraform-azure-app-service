##----------------------------------------------------------------------------- 
## App Service
##-----------------------------------------------------------------------------

variable "linux_sku_name" {
  default = "B1"

}

variable "os_type" {
  default = "Linux"
}

variable "enable" {
  default = true
}

variable "is_linux_webapp" {
  default = true
}

variable "dotnet_version" {
  default = "8.0"
}

variable "node_version" {
  default = "20-lts"
}

variable "site_config" {
  default = {
    container_registry_use_managed_identity = true # Set to true 
  }
}

variable "app_settings" {
  type        = map(string)
  description = "A map of settings for the application"
  default = {
    foo = "bar"
  }
}

variable "php_version" {
  type    = string
  default = "8.2"
}

variable "python_version" {
  type    = string
  default = "3.12"
}

variable "go_version" {
  type    = string
  default = "1.19"
}

variable "ruby_version" {
  type    = string
  default = "2.7"
}

variable "java_version" {
  type    = string
  default = "17"
}

variable "java_server" {
  type    = string
  default = "JAVA"
  # Possible values include JAVA, TOMCAT, and JBOSSEAP ( Its in premium sku ).
}

variable "java_server_version" {
  type    = string
  default = "17"
}

variable "docker_image_name" {
  default = "nginx:latest"
}

variable "app_service_logs" {
  default = {
    detailed_error_messages = false
    failed_request_tracing  = false
    application_logs = {
      file_system_level = "Information"
    }
    http_logs = {
      file_system = {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}
