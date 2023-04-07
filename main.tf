
## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.


module "labels" {

  source  = "clouddrove/labels/azure"
  version = "1.0.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

locals {

  # app insights
  app_insights = try(data.azurerm_application_insights.main.0, try(azurerm_application_insights.main.0, {}))

  default_app_settings = var.application_insights_enabled ? {
    APPLICATION_INSIGHTS_IKEY                  = try(local.app_insights.instrumentation_key, "")
    APPINSIGHTS_INSTRUMENTATIONKEY             = try(local.app_insights.instrumentation_key, "")
    APPLICATIONINSIGHTS_CONNECTION_STRING      = try(local.app_insights.connection_string, "")
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
  } : {}

  # Default configuration for Site config block
  default_site_config = {
    always_on = "true"
  }

  ip_address = [for ip_address in var.ips_allowed : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.ips_allowed, ip_address)])}"
    ip_address                = ip_address
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.ips_allowed, ip_address)])
    action                    = "Allow"
  }]

  subnets = [for subnet in var.subnet_ids_allowed : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.subnet_ids_allowed, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.subnet_ids_allowed, subnet)])
    action                    = "Allow"
  }]
}

data "azurerm_client_config" "main" {}

## APP SERVICE PLAN

resource "azurerm_app_service_plan" "main" {
  name                = format("app-service-plan-%s", lower(replace(module.labels.id, "/[[:^alnum:]]/", "")))
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = var.service_plan.kind
  reserved            = var.service_plan.kind == "Linux" ? true : false
  is_xenon            = var.service_plan.kind == "xenon" ? true : false
  per_site_scaling    = var.service_plan.per_site_scaling
  tags                = module.labels.tags

  sku {
    tier     = var.service_plan.tier
    size     = var.service_plan.size
    capacity = var.service_plan.capacity
  }
}

## APP SERVICE

resource "azurerm_app_service" "main" {
  count                   = var.enabled ? 1 : 0
  name                    = lower(format("%s-app-service", module.labels.id))
  resource_group_name     = var.resource_group_name
  location                = var.location
  app_service_plan_id     = azurerm_app_service_plan.main.id
  client_affinity_enabled = var.enable_client_affinity
  https_only              = var.enable_https
  client_cert_enabled     = var.enable_client_certificate
  tags                    = module.labels.tags
  app_settings            = merge(local.default_app_settings, var.app_settings)

  dynamic "site_config" {
    for_each = [merge(local.default_site_config, var.site_config)]

    content {
      always_on                 = lookup(site_config.value, "always_on", false)
      app_command_line          = lookup(site_config.value, "app_command_line", null)
      default_documents         = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version  = lookup(site_config.value, "dotnet_framework_version", "v2.0")
      ftps_state                = lookup(site_config.value, "ftps_state", "FtpsOnly")
      health_check_path         = lookup(site_config.value, "health_check_path", null)
      ip_restriction            = concat(local.subnets, local.ip_address)
      number_of_workers         = var.service_plan.per_site_scaling == true ? lookup(site_config.value, "number_of_workers") : null
      http2_enabled             = lookup(site_config.value, "http2_enabled", false)
      java_container            = lookup(site_config.value, "java_container", null)
      java_container_version    = lookup(site_config.value, "java_container_version", null)
      java_version              = lookup(site_config.value, "java_version", null)
      local_mysql_enabled       = lookup(site_config.value, "local_mysql_enabled", null)
      linux_fx_version          = lookup(site_config.value, "linux_fx_version", null)
      windows_fx_version        = lookup(site_config.value, "windows_fx_version", null)
      managed_pipeline_mode     = lookup(site_config.value, "managed_pipeline_mode", "Integrated")
      min_tls_version           = lookup(site_config.value, "min_tls_version", "1.2")
      php_version               = lookup(site_config.value, "php_version", null)
      python_version            = lookup(site_config.value, "python_version", null)
      remote_debugging_enabled  = lookup(site_config.value, "remote_debugging_enabled", null)
      remote_debugging_version  = lookup(site_config.value, "remote_debugging_version", null)
      scm_type                  = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process = lookup(site_config.value, "use_32_bit_worker_process", true)
      websockets_enabled        = lookup(site_config.value, "websockets_enabled", null)
    }
  }

  auth_settings {
    enabled                        = var.enable_auth_settings
    default_provider               = var.default_auth_provider
    allowed_external_redirect_urls = []
    issuer                         = format("https://sts.windows.net/%s/", data.azurerm_client_config.main.tenant_id)
    unauthenticated_client_action  = var.unauthenticated_client_action
    token_store_enabled            = var.token_store_enabled

    dynamic "active_directory" {
      for_each = var.active_directory_auth_setttings
      content {
        client_id         = lookup(active_directory_auth_setttings.value, "client_id", null)
        client_secret     = lookup(active_directory_auth_setttings.value, "client_secret", null)
        allowed_audiences = concat(formatlist("https://%s", [format("%s.azurewebsites.net", var.app_service_name)]), [])
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }

  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }

  dynamic "storage_account" {
    for_each = var.storage_mounts
    content {
      name         = lookup(storage_account.value, "name")
      type         = lookup(storage_account.value, "type", "AzureFiles")
      account_name = lookup(storage_account.value, "account_name", null)
      share_name   = lookup(storage_account.value, "share_name", null)
      access_key   = lookup(storage_account.value, "access_key", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
      site_config,
      auth_settings,
      storage_account,
      identity,
      connection_string,
    ]
  }
}

locals {
  resource_group_name   = var.resource_group_name
  location              = var.location
  valid_rg_name         = var.existing_private_dns_zone == null ? local.resource_group_name : (var.existing_private_dns_zone_resource_group_name == "" ? local.resource_group_name : var.existing_private_dns_zone_resource_group_name)
  private_dns_zone_name = var.existing_private_dns_zone == null ? join("", azurerm_private_dns_zone.dnszone.*.name) : var.existing_private_dns_zone
}

resource "azurerm_private_endpoint" "pep" {
  count               = var.enabled && var.enable_private_endpoint ? 1 : 0
  name                = format("%s-pe-app-service", module.labels.id)
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.subnet_id
  tags                = module.labels.tags
  private_service_connection {
    name                           = format("%s-psc-app-service", module.labels.id)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_app_service.main[0].id
    subresource_names              = ["sites"]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

data "azurerm_private_endpoint_connection" "private-ip-0" {
  count               = var.enabled && var.enable_private_endpoint ? 1 : 0
  name                = join("", azurerm_private_endpoint.pep.*.name)
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_app_service.main]
}

resource "azurerm_private_dns_zone" "dnszone" {
  count               = var.enabled && var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.azurewebsites.net"
  resource_group_name = local.resource_group_name
  tags                = module.labels.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vent-link" {
  count                 = var.enabled && var.enable_private_endpoint && (var.existing_private_dns_zone != null ? (var.existing_private_dns_zone_resource_group_name == "" ? false : true) : true) ? 1 : 0
  name                  = var.existing_private_dns_zone == null ? format("%s-pdz-vnet-link-app-service", module.labels.id) : format("%s-pdz-vnet-link-app-service-1", module.labels.id)
  resource_group_name   = local.valid_rg_name
  private_dns_zone_name = local.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  tags                  = module.labels.tags
}

# App Insights

data "azurerm_application_insights" "main" {
  count               = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0
  name                = split("/", var.application_insights_id)[8]
  resource_group_name = split("/", var.application_insights_id)[4]
}

resource "azurerm_application_insights" "main" {
  count               = var.application_insights_enabled && var.application_insights_id == null ? 1 : 0
  name                = lower(format("app-insights-%s", var.app_insights_name))
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights_type
  retention_in_days   = var.retention_in_days
  disable_ip_masking  = var.disable_ip_masking
  tags                = merge({ "ResourceName" = "${var.app_insights_name}" }, module.labels.tags, )
}

# VNET integration

resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  count          = var.enable_vnet_integration == true ? 1 : 0
  app_service_id = azurerm_app_service.main[0].id
  subnet_id      = var.integration_subnet_id
}
