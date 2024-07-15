# App Service Plan

variable "windows_sku_name"{
  default = "S1"
}

variable "windows_os_type" {
  default = "Windows"
}

variable "linux_sku_name"{
  default = "B1"
  
}

variable "linux_os_type" {
  default = "Linux"
  
}

variable "enable" {
  default = true
}

variable "is_linux_webapp" {
  default = true
}

