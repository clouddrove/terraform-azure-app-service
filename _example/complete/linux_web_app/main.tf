provider "azurerm" {
  features {}
  subscription_id = "000000-11111-1223-XXX-XXXXXXXXXXXX"
}

##----------------------------------------------------------------------------- 
## Resource group
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.2"
  label_order = ["name", "environment"]
  name        = "rg-example"
  environment = "test"
  location    = "Canada Central"
}

##----------------------------------------------------------------------------- 
## Log Analytics
##-----------------------------------------------------------------------------
module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "1.1.0"
  name                             = "app"
  environment                      = "test"
  label_order                      = ["name", "environment"]
  create_log_analytics_workspace   = true
  log_analytics_workspace_sku      = "PerGB2018"
  resource_group_name              = module.resource_group.resource_group_name
  log_analytics_workspace_location = module.resource_group.resource_group_location
  log_analytics_workspace_id       = module.log-analytics.workspace_id
}

##----------------------------------------------------------------------------- 
## Linux web app
##-----------------------------------------------------------------------------
module "linux-web-app" {
  source              = "../../.."
  enable              = true
  name                = "app"
  environment         = "testing"
  label_order         = ["name", "environment", ]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  os_type             = var.os_type
  sku_name            = var.linux_sku_name

  ##----------------------------------------------------------------------------- 
  ## To Deploy Container
  ##-----------------------------------------------------------------------------
  use_docker               = false
  docker_image_name        = var.docker_image_name
  docker_registry_url      = "<registryname>.azurecr.io"
  docker_registry_username = "<registryname>"
  docker_registry_password = "<docker_registry_password>"
  acr_id                   = "<acr_id>"

  ##----------------------------------------------------------------------------- 
  ## Node application
  ##-----------------------------------------------------------------------------
  use_node     = true
  node_version = var.node_version

  ##----------------------------------------------------------------------------- 
  ## Dot net application
  ##-----------------------------------------------------------------------------
  use_dotnet     = false
  dotnet_version = var.dotnet_version

  ##----------------------------------------------------------------------------- 
  ## Java application
  ##-----------------------------------------------------------------------------
  use_java            = false
  java_version        = var.java_version
  java_server         = var.java_server
  java_server_version = var.java_server_version

  ##----------------------------------------------------------------------------- 
  ## python application
  ##-----------------------------------------------------------------------------

  use_python     = false
  python_version = var.python_version

  ##----------------------------------------------------------------------------- 
  ## php application
  ##-----------------------------------------------------------------------------

  use_php     = false
  php_version = var.php_version

  ##----------------------------------------------------------------------------- 
  ## Ruby application
  ##-----------------------------------------------------------------------------

  use_ruby     = false
  ruby_version = var.ruby_version

  ##----------------------------------------------------------------------------- 
  ## Go application
  ##-----------------------------------------------------------------------------

  use_go     = false
  go_version = var.go_version

  site_config  = var.site_config
  app_settings = var.app_settings

  ##----------------------------------------------------------------------------- 
  ## App service logs 
  ##----------------------------------------------------------------------------- 

  app_service_logs = var.app_service_logs

  ##----------------------------------------------------------------------------- 
  ## log analytics
  ##-----------------------------------------------------------------------------
  log_analytics_workspace_id = module.log-analytics.workspace_id
  app_insights_workspace_id  = module.log-analytics.workspace_id # log analytics workspace id in app insights
}

