provider "azurerm" {
  features {}
  subscription_id = "000000-11111-1223-XXX-XXXXXXXXXXXX"
}

##----------------------------------------------------------------------------- 
## Local declaration
##-----------------------------------------------------------------------------
locals {
  name        = "test"
  environment = "dev"
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

##----------------------------------------------------------------------------- 
## Resource group
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.2"
  name        = local.name
  environment = local.environment
  label_order = local.label_order
  location    = local.location
}

##----------------------------------------------------------------------------- 
## Vnet
##-----------------------------------------------------------------------------
module "vnet" {
  source              = "clouddrove/vnet/azure"
  version             = "1.0.4"
  name                = local.name
  environment         = local.environment
  label_order         = local.label_order
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##----------------------------------------------------------------------------- 
## Subnet
##-----------------------------------------------------------------------------
module "subnet" {
  source               = "clouddrove/subnet/azure"
  version              = "1.2.1"
  name                 = local.name
  environment          = local.environment
  label_order          = local.label_order
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name

  #subnet
  subnet_names    = ["subnet1", "subnet2"]
  subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]

  delegation = {
    "subnet2" = [{
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }]
  }

  # route_table
  enable_route_table = false
  route_table_name   = "pub"
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

##----------------------------------------------------------------------------- 
## Private endpoint Subnet 
##-----------------------------------------------------------------------------
module "subnet-ep" {
  source               = "clouddrove/subnet/azure"
  version              = "1.2.1"
  name                 = "ep-subnet"
  environment          = local.environment
  label_order          = local.label_order
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name

  #subnet
  subnet_names    = ["sub3", "sub4"]
  subnet_prefixes = ["10.0.3.0/24", "10.0.4.0/24"]

  # route_table
  enable_route_table = false
  route_table_name   = "pub"
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

##----------------------------------------------------------------------------- 
## Log Analytics
##-----------------------------------------------------------------------------
module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "1.1.0"
  name                             = local.name
  environment                      = local.environment
  label_order                      = local.label_order
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
  name                = local.name
  environment         = local.environment
  label_order         = local.label_order
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  os_type             = "Linux"
  sku_name            = "B1"

  ##----------------------------------------------------------------------------- 
  ## To Deploy Container
  ##-----------------------------------------------------------------------------
  use_docker               = false
  docker_image_name        = "nginx:latest"
  docker_registry_url      = "<registryname>.azurecr.io"
  docker_registry_username = "<registryname>"
  docker_registry_password = "<docker_registry_password>"
  acr_id                   = "<acr_id>"

  ##----------------------------------------------------------------------------- 
  ## Node application
  ##-----------------------------------------------------------------------------
  use_node     = false
  node_version = "20-lts"

  ##----------------------------------------------------------------------------- 
  ## Dot net application
  ##-----------------------------------------------------------------------------
  use_dotnet     = true
  dotnet_version = "8.0"

  ##----------------------------------------------------------------------------- 
  ## Java application
  ##-----------------------------------------------------------------------------
  use_java            = false
  java_version        = "17"
  java_server         = "JAVA"
  java_server_version = "17"

  ##----------------------------------------------------------------------------- 
  ## python application
  ##-----------------------------------------------------------------------------

  use_python     = false
  python_version = "3.12"

  ##----------------------------------------------------------------------------- 
  ## php application
  ##-----------------------------------------------------------------------------

  use_php     = false
  php_version = "8.2"

  ##----------------------------------------------------------------------------- 
  ## Ruby application
  ##-----------------------------------------------------------------------------

  use_ruby     = false
  ruby_version = "2.7"

  ##----------------------------------------------------------------------------- 
  ## Go application
  ##-----------------------------------------------------------------------------

  use_go     = false
  go_version = "1.19"

  site_config = var.site_config

  # To enable app insights 
  app_settings = {
    application_insights_connection_string     = "${module.linux-web-app.connection_string}"
    application_insights_key                   = "${module.linux-web-app.instrumentation_key}"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }

  ##----------------------------------------------------------------------------- 
  ## App service logs 
  ##----------------------------------------------------------------------------- 

  app_service_logs = var.app_service_logs

  ##----------------------------------------------------------------------------- 
  ## log analytics
  ##-----------------------------------------------------------------------------
  log_analytics_workspace_id = module.log-analytics.workspace_id

  ##----------------------------------------------------------------------------- 
  ## Vnet integration and private endpoint
  ##-----------------------------------------------------------------------------
  virtual_network_id                     = module.vnet.vnet_id
  private_endpoint_subnet_id             = module.subnet-ep.default_subnet_id[0] # Normal subnet for private endpoint from ep-subnet
  enable_private_endpoint                = true
  app_service_vnet_integration_subnet_id = module.subnet.default_subnet_id[1] # delegated subnet id for vnet integration
  public_network_access_enabled          = false
}

