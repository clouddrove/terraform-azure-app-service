variable "windows_sku_name" {
  default = "S1"
}

variable "os_type" {
  default = "Windows"
}

variable "enable" {
  default = true
}

variable "dotnet_version" {
  default = "v8.0"
}

variable "dotnet_core_version" {
  default = "v4.0"
}

variable "node_version" {
  default = "~20"
}

variable "python_version" {
  default = "1.8.0"
}

variable "php_version" {
  default = "8.3"
}

variable "java_version" {
  default = "17"
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

variable "docker_image_name" {
  default = "nginx-test:latest" # Windows-based Docker image should be used here
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
