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

# APP Service
module "app-service" {
  source              = "../../"
  enabled             = true
  name                = "app"
  environment         = "teting"
  label_order         = ["name", "environment", ]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  enable_auth_settings      = true
  enable_client_certificate = true

  service_plan = {
    kind = "Windows"
    size = "S1"
    tier = "Free"
  }

  app_service_name       = "test-app-service"
  enable_client_affinity = true
  enable_https           = true

  site_config = {
    use_32_bit_worker_process = true
    http2_enabled             = true
    windows_fx_version        = "node|18-lts"
  }

  app_settings = {
    WEBSITE_NODE_DEFAULT_VERSION = "~16"
  }
}