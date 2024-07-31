provider "azurerm" {
  features {}
}

##----------------------------------------------------------------------------- 
## Resource group
##-----------------------------------------------------------------------------
module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.2"

  label_order = ["name", "environment"]
  name        = "rg-example"
  environment = "test"
  location    = "Canada Central"
}

module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "1.0.1"
  name                             = "app"
  environment                      = "test"
  label_order                      = ["name", "environment"]
  create_log_analytics_workspace   = true
  log_analytics_workspace_sku      = "PerGB2018"
  resource_group_name              = module.resource_group.resource_group_name
  log_analytics_workspace_location = module.resource_group.resource_group_location
}

##----------------------------------------------------------------------------- 
## Windows web app 
##-----------------------------------------------------------------------------
module "windows-web-app" {
  source              = "../../.."
  enable              = true
  name                = "app"
  environment         = "testing"
  label_order         = ["name", "environment", ]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  os_type  = var.os_type
  sku_name = var.windows_sku_name

  ##----------------------------------------------------------------------------- 
  ## log analytics
  ##-----------------------------------------------------------------------------
  log_analytics_workspace_id = module.log-analytics.workspace_id
  app_insights_workspace_id  = module.log-analytics.workspace_id

  ##----------------------------------------------------------------------------- 
  ## app service logs
  ##-----------------------------------------------------------------------------
  app_service_logs = var.app_service_logs


  site_config  = var.site_config
  app_settings = var.app_settings

  ##----------------------------------------------------------------------------- 
  ## Current stack ( Possible values -> dotnet, dotnetcore, node, python, php, and java )
  ##-----------------------------------------------------------------------------

  current_stack = "dotnet" # Specify runtime stack here

  ##----------------------------------------------------------------------------- 
  ## Dot net
  ##-----------------------------------------------------------------------------
  use_dotnet          = false                   # Make it true if want to use it 
  dotnet_version      = var.dotnet_version      # For dotnet
  dotnet_core_version = var.dotnet_core_version # For dotnetcore

  ##----------------------------------------------------------------------------- 
  ## Node application
  ##-----------------------------------------------------------------------------
  use_node     = false
  node_version = var.node_version

  ##----------------------------------------------------------------------------- 
  ## python application
  ##-----------------------------------------------------------------------------

  use_python = false # Can only be a bool (true to use it)

  ##----------------------------------------------------------------------------- 
  ## php application
  ##-----------------------------------------------------------------------------

  use_php     = false
  php_version = var.php_version

  ##----------------------------------------------------------------------------- 
  ## java application
  ##-----------------------------------------------------------------------------

  use_java     = true
  java_version = var.java_version

  ##----------------------------------------------------------------------------- 
  ## To Deploy Docker Container
  ##-----------------------------------------------------------------------------

  use_docker               = true # Make it true if want to use it 
  docker_image_name        = var.docker_image_name
  docker_registry_url      = "<registryname>.azurecr.io"
  docker_registry_username = "<registryname>"
  docker_registry_password = "<docker_registry_password>"
  acr_id                   = "<acr_id>"

}