provider "azurerm" {
  features {}
}

# Resource Group
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

# APP Service
module "windows-web-app" {
  source              = "../../"
  # enable              = true
  count               = var.enable && var.is_linux_webapp ? 0 :1
  name                = "app"
  environment         = "testing"
  label_order         = ["name", "environment", ]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  os_type  = var.windows_os_type
  sku_name = var.windows_sku_name

    #log-analytics
  log_analytics_workspace_id = module.log-analytics.workspace_id
  app_insights_workspace_id = module.log-analytics.workspace_id # insights mein log analytics ki workspace id 

  #app-service logs
  # app_service_logs = var.app_service_logs


  # service_plan = {
  #   kind = "Windows"
  #   size = "S1"
  #   tier = "Free"
  # }

  # app_service_name       = "test-app-service"
  # enable_client_affinity = true
  # enable_https           = true

  site_config = {
    use_32_bit_worker_process = true 
  }

  # site_config         = var.site_config
  # app_settings        = var.app_settings



  app_settings = {
    WEBSITE_NODE_DEFAULT_VERSION = "~16" 
    # linux_fx_version        = "node|18-lts"
  }
}


# APP Service
module "linux-web-app" {
  source              = "../../"
  # enable              = true
  count               = var.enable && var.is_linux_webapp ? 1 : 0
  name                = "app"
  environment         = "testing"
  label_order         = ["name", "environment", ]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  os_type  = var.linux_os_type
  sku_name = var.linux_sku_name

    #log-analytics
  log_analytics_workspace_id = module.log-analytics.workspace_id
  app_insights_workspace_id = module.log-analytics.workspace_id # insights mein log analytics ki workspace id 

  #app-service logs
  # app_service_logs = var.app_service_logs


  # service_plan = {
  #   kind = "Windows"
  #   size = "S1"
  #   tier = "Free"
  # }

  # app_service_name       = "test-app-service"
  # enable_client_affinity = true
  # enable_https           = true

  site_config = {
    use_32_bit_worker_process = true 
  }

  # site_config         = var.site_config
  # app_settings        = var.app_settings



  app_settings = {
    WEBSITE_NODE_DEFAULT_VERSION = "~16" 
    # linux_fx_version        = "node|18-lts"
  }
}


