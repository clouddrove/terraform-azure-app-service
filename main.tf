
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

#---------------------------------------------DATA-----------------------------------------------#
data "azurerm_client_config" "main" {}

#---------------------------------------------APP SERVICE PLAN-----------------------------------------------#
resource "azurerm_service_plan" "main" {
  count               = var.enable ? 1 : 0
  name                = format("%s-asp", module.labels.id)
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type                      = var.os_type
  sku_name                     = var.sku_name
  worker_count                 = var.sku_name == "B1" ? null : var.worker_count
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  app_service_environment_id   = var.app_service_environment_id
  per_site_scaling_enabled     = var.per_site_scaling_enabled
  tags                         = module.labels.tags
}

#---------------------------------------------Locals-----------------------------------------------------#
locals {
  default_site_config = {
    always_on               = "true"
    scm_minimum_tls_version = "1.2"
  }

  site_config = merge(local.default_site_config, var.site_config)

  subnets = [for subnet in var.authorized_subnet_ids : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.authorized_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.authorized_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  ip_restriction_headers = var.ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.ip_restriction_headers)] : []

  cidrs = [for cidr in var.authorized_ips : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.authorized_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_ips, cidr)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  default_ip_restrictions_headers = {
    x_azure_fdid      = null
    x_fd_health_probe = null
    x_forwarded_for   = null
    x_forwarded_host  = null
  }

  scm_subnets = [for subnet in var.scm_authorized_subnet_ids : {
    name                      = "scm_ip_restriction_subnet_${join("", [1, index(var.scm_authorized_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.scm_authorized_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_ip_restriction_headers = var.scm_ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.scm_ip_restriction_headers)] : []

  service_tags = [for service_tag in var.authorized_service_tags : {
    name                      = "service_tag_restriction_${join("", [1, index(var.authorized_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  scm_cidrs = [for cidr in var.scm_authorized_ips : {
    name                      = "scm_ip_restriction_cidr_${join("", [1, index(var.scm_authorized_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.scm_authorized_ips, cidr)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_service_tags = [for service_tag in var.scm_authorized_service_tags : {
    name                      = "scm_service_tag_restriction_${join("", [1, index(var.scm_authorized_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.scm_authorized_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  app_insights = try(data.azurerm_application_insights.app_insights[0], try(azurerm_application_insights.app_insights[0], {}))


  app_settings = merge(local.default_app_settings, var.app_settings)
  default_app_settings = var.application_insights_enabled ? {
    APPLICATION_INSIGHTS_IKEY             = try(local.app_insights.instrumentation_key, "")
    APPINSIGHTS_INSTRUMENTATIONKEY        = try(local.app_insights.instrumentation_key, "")
    APPLICATIONINSIGHTS_CONNECTION_STRING = try(local.app_insights.connection_string, "")
  } : {}

  auth_settings_active_directory = merge(
    {
      client_id         = null
      client_secret     = null
      allowed_audiences = []
    },
  local.auth_settings.active_directory == null ? local.auth_settings_ad_default : var.auth_settings.active_directory)
  auth_settings_ad_default = {
    client_id         = null
    client_secret     = null
    allowed_audiences = []
  }

  auth_settings = merge(
    {
      enabled                        = false
      issuer                         = format("https://sts.windows.net/%s/", data.azurerm_client_config.main.tenant_id)
      token_store_enabled            = false
      unauthenticated_client_action  = "RedirectToLoginPage"
      default_provider               = "AzureActiveDirectory"
      allowed_external_redirect_urls = []
      active_directory               = null
    },
  var.auth_settings)


  auth_settings_v2_login_default = {
    token_store_enabled               = false
    token_refresh_extension_time      = 72
    preserve_url_fragments_for_logins = false
    cookie_expiration_convention      = "FixedTime"
    cookie_expiration_time            = "08:00:00"
    validate_nonce                    = true
    nonce_expiration_time             = "00:05:00"
  }

  auth_settings_v2_login = try(var.auth_settings_v2.login, null) == null ? local.auth_settings_v2_login_default : var.auth_settings_v2.login
  resource_group_name   = var.resource_group_name
  location              = var.location
  valid_rg_name         = var.existing_private_dns_zone == null ? local.resource_group_name : (var.existing_private_dns_zone_resource_group_name == "" ? local.resource_group_name : var.existing_private_dns_zone_resource_group_name)
  private_dns_zone_name = var.existing_private_dns_zone == null ? join("", azurerm_private_dns_zone.dnszone.*.name) : var.existing_private_dns_zone
}

#---------------------------------------------Linux web app-----------------------------------------------------#

resource "azurerm_linux_web_app" "main" {
  # count               = var.enable_linux_web_app ? 1 : 0
  count               = var.enable && var.is_linux_webapp ? 1 : 0
  name                = format("%s-linux-app", module.labels.id)
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main[0].id

  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.app_service_vnet_integration_subnet_id


  dynamic "site_config" {
    for_each = [local.site_config]

    content {
      linux_fx_version = lookup(site_config.value, "linux_fx_version", null) # ----> Added
      container_registry_managed_identity_client_id = lookup(site_config.value, "container_registry_managed_identity_client_id", null)
      container_registry_use_managed_identity       = lookup(site_config.value, "container_registry_use_managed_identity", null)

      always_on                = lookup(site_config.value, "always_on", null)
      app_command_line         = lookup(site_config.value, "app_command_line", null)
      default_documents        = lookup(site_config.value, "default_documents", null)
      ftps_state               = lookup(site_config.value, "ftps_state", "FtpsOnly")
      health_check_path        = lookup(site_config.value, "health_check_path", null)
      http2_enabled            = lookup(site_config.value, "http2_enabled", null)
      local_mysql_enabled      = lookup(site_config.value, "local_mysql_enabled", false)
      managed_pipeline_mode    = lookup(site_config.value, "managed_pipeline_mode", null)
      minimum_tls_version      = lookup(site_config.value, "minimum_tls_version", lookup(site_config.value, "min_tls_version", "1.2"))
      remote_debugging_enabled = lookup(site_config.value, "remote_debugging_enabled", false)
      remote_debugging_version = lookup(site_config.value, "remote_debugging_version", null)
      use_32_bit_worker        = lookup(site_config.value, "use_32_bit_worker", false)
      websockets_enabled       = lookup(site_config.value, "websockets_enabled", false)

      dynamic "ip_restriction" {
        for_each = concat(local.subnets, local.cidrs, local.service_tags)
        content {
          name                      = ip_restriction.value.name
          ip_address                = ip_restriction.value.ip_address
          virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
          service_tag               = ip_restriction.value.service_tag
          priority                  = ip_restriction.value.priority
          action                    = ip_restriction.value.action
          headers                   = ip_restriction.value.headers
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
        content {
          name                      = scm_ip_restriction.value.name
          ip_address                = scm_ip_restriction.value.ip_address
          virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
          service_tag               = scm_ip_restriction.value.service_tag
          priority                  = scm_ip_restriction.value.priority
          action                    = scm_ip_restriction.value.action
          headers                   = scm_ip_restriction.value.headers
        }
      }

      # scm_type                    = lookup(site_config.value, "scm_type", null)
      scm_minimum_tls_version     = lookup(site_config.value, "scm_minimum_tls_version", "1.2")
      scm_use_main_ip_restriction = length(var.scm_authorized_ips) > 0 || var.scm_authorized_subnet_ids != null ? false : true

      vnet_route_all_enabled = var.app_service_vnet_integration_subnet_id != null

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dotnet_version      = lookup(local.site_config.application_stack, "dotnet_version", null)
          java_server         = lookup(local.site_config.application_stack, "java_server", null)
          java_server_version = lookup(local.site_config.application_stack, "java_server_version", null)
          java_version        = lookup(local.site_config.application_stack, "java_version", null)
          node_version        = lookup(local.site_config.application_stack, "node_version", null)
          php_version         = lookup(local.site_config.application_stack, "php_version", null)
          python_version      = lookup(local.site_config.application_stack, "python_version", null)
          ruby_version        = lookup(local.site_config.application_stack, "ruby_version", null)
        }
      }

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", [])
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
    }
  }

  app_settings = var.staging_slot_custom_app_settings == null ? local.app_settings : merge(local.default_app_settings, var.staging_slot_custom_app_settings)

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }


  dynamic "auth_settings" {
    for_each = local.auth_settings.enabled ? ["enabled"] : []
    content {
      enabled                        = local.auth_settings.enabled
      issuer                         = local.auth_settings.issuer
      token_store_enabled            = local.auth_settings.token_store_enabled
      unauthenticated_client_action  = local.auth_settings.unauthenticated_client_action
      default_provider               = local.auth_settings.default_provider
      allowed_external_redirect_urls = local.auth_settings.allowed_external_redirect_urls

      dynamic "active_directory" {
        for_each = local.auth_settings_active_directory.client_id == null ? [] : [local.auth_settings_active_directory]
        content {
          client_id         = local.auth_settings_active_directory.client_id
          client_secret     = local.auth_settings_active_directory.client_secret
          allowed_audiences = concat(formatlist("https://%s", [format("%s.azurewebsites.net", format("%s-app", module.labels.id))]), local.auth_settings_active_directory.allowed_audiences)
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = lookup(var.auth_settings_v2, "auth_enabled", false) ? [var.auth_settings_v2] : []
    content {
      auth_enabled                            = lookup(auth_settings_v2.value, "auth_enabled", false)
      runtime_version                         = lookup(auth_settings_v2.value, "runtime_version", "~1")
      config_file_path                        = lookup(auth_settings_v2.value, "config_file_path", null)
      require_authentication                  = lookup(auth_settings_v2.value, "require_authentication", null)
      unauthenticated_action                  = lookup(auth_settings_v2.value, "unauthenticated_action", "RedirectToLoginPage")
      default_provider                        = lookup(auth_settings_v2.value, "default_provider", "azureactivedirectory")
      excluded_paths                          = lookup(auth_settings_v2.value, "excluded_paths", null)
      require_https                           = lookup(auth_settings_v2.value, "require_https", true)
      http_route_api_prefix                   = lookup(auth_settings_v2.value, "http_route_api_prefix", "/.auth")
      forward_proxy_convention                = lookup(auth_settings_v2.value, "forward_proxy_convention", "ForwardProxyConventionNoProxy")
      forward_proxy_custom_host_header_name   = lookup(auth_settings_v2.value, "forward_proxy_custom_host_header_name", null)
      forward_proxy_custom_scheme_header_name = lookup(auth_settings_v2.value, "forward_proxy_custom_scheme_header_name", null)

      dynamic "apple_v2" {
        for_each = try(var.auth_settings_v2.apple_v2[*], [])
        content {
          client_id                  = lookup(apple_v2.value, "client_id", null)
          client_secret_setting_name = lookup(apple_v2.value, "client_secret_setting_name", null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = try(var.auth_settings_v2.active_directory_v2[*], [])

        content {
          client_id                            = lookup(active_directory_v2.value, "client_id", null)
          tenant_auth_endpoint                 = lookup(active_directory_v2.value, "tenant_auth_endpoint", null)
          client_secret_setting_name           = lookup(active_directory_v2.value, "client_secret_setting_name", null)
          client_secret_certificate_thumbprint = lookup(active_directory_v2.value, "client_secret_certificate_thumbprint", null)
          jwt_allowed_groups                   = lookup(active_directory_v2.value, "jwt_allowed_groups", null)
          jwt_allowed_client_applications      = lookup(active_directory_v2.value, "jwt_allowed_client_applications", null)
          www_authentication_disabled          = lookup(active_directory_v2.value, "www_authentication_disabled", false)
          allowed_groups                       = lookup(active_directory_v2.value, "allowed_groups", null)
          allowed_identities                   = lookup(active_directory_v2.value, "allowed_identities", null)
          allowed_applications                 = lookup(active_directory_v2.value, "allowed_applications", null)
          login_parameters                     = lookup(active_directory_v2.value, "login_parameters", null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = try(var.auth_settings_v2.azure_static_web_app_v2[*], [])
        content {
          client_id = lookup(azure_static_web_app_v2.value, "client_id", null)
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(var.auth_settings_v2.custom_oidc_v2[*], [])
        content {
          name                          = lookup(custom_oidc_v2.value, "name", null)
          client_id                     = lookup(custom_oidc_v2.value, "client_id", null)
          openid_configuration_endpoint = lookup(custom_oidc_v2.value, "openid_configuration_endpoint", null)
          name_claim_type               = lookup(custom_oidc_v2.value, "name_claim_type", null)
          scopes                        = lookup(custom_oidc_v2.value, "scopes", null)
          client_credential_method      = lookup(custom_oidc_v2.value, "client_credential_method", null)
          client_secret_setting_name    = lookup(custom_oidc_v2.value, "client_secret_setting_name", null)
          authorisation_endpoint        = lookup(custom_oidc_v2.value, "authorisation_endpoint", null)
          token_endpoint                = lookup(custom_oidc_v2.value, "token_endpoint", null)
          issuer_endpoint               = lookup(custom_oidc_v2.value, "issuer_endpoint", null)
          certification_uri             = lookup(custom_oidc_v2.value, "certification_uri", null)
        }
      }

      dynamic "facebook_v2" {
        for_each = try(var.auth_settings_v2.facebook_v2[*], [])
        content {
          app_id                  = lookup(facebook_v2.value, "app_id", null)
          app_secret_setting_name = lookup(facebook_v2.value, "app_secret_setting_name", null)
          graph_api_version       = lookup(facebook_v2.value, "graph_api_version", null)
          login_scopes            = lookup(facebook_v2.value, "login_scopes", null)
        }
      }

      dynamic "github_v2" {
        for_each = try(var.auth_settings_v2.github_v2[*], [])
        content {
          client_id                  = lookup(github_v2.value, "client_id", null)
          client_secret_setting_name = lookup(github_v2.value, "client_secret_setting_name", null)
          login_scopes               = lookup(github_v2.value, "login_scopes", null)
        }
      }

      dynamic "google_v2" {
        for_each = try(var.auth_settings_v2.google_v2[*], [])
        content {
          client_id                  = lookup(google_v2.value, "client_id", null)
          client_secret_setting_name = lookup(google_v2.value, "client_secret_setting_name", null)
          allowed_audiences          = lookup(google_v2.value, "allowed_audiences", null)
          login_scopes               = lookup(google_v2.value, "login_scopes", null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = try(var.auth_settings_v2.microsoft_v2[*], [])
        content {
          client_id                  = lookup(microsoft_v2.value, "client_id", null)
          client_secret_setting_name = lookup(microsoft_v2.value, "client_secret_setting_name", null)
          allowed_audiences          = lookup(microsoft_v2.value, "allowed_audiences", null)
          login_scopes               = lookup(microsoft_v2.value, "login_scopes", null)
        }
      }

      dynamic "twitter_v2" {
        for_each = try(var.auth_settings_v2.twitter_v2[*], [])
        content {
          consumer_key                 = lookup(twitter_v2.value, "consumer_key", null)
          consumer_secret_setting_name = lookup(twitter_v2.value, "consumer_secret_setting_name", null)
        }
      }

      login {
        logout_endpoint                   = lookup(local.auth_settings_v2_login, "logout_endpoint", null)
        cookie_expiration_convention      = lookup(local.auth_settings_v2_login, "cookie_expiration_convention", "FixedTime")
        cookie_expiration_time            = lookup(local.auth_settings_v2_login, "cookie_expiration_time", "08:00:00")
        preserve_url_fragments_for_logins = lookup(local.auth_settings_v2_login, "preserve_url_fragments_for_logins", false)
        token_refresh_extension_time      = lookup(local.auth_settings_v2_login, "token_refresh_extension_time", 72)
        token_store_enabled               = lookup(local.auth_settings_v2_login, "token_store_enabled", false)
        token_store_path                  = lookup(local.auth_settings_v2_login, "token_store_path", null)
        token_store_sas_setting_name      = lookup(local.auth_settings_v2_login, "token_store_sas_setting_name", null)
        validate_nonce                    = lookup(local.auth_settings_v2_login, "validate_nonce", true)
        nonce_expiration_time             = lookup(local.auth_settings_v2_login, "nonce_expiration_time", "00:05:00")
      }
    }
  }

  client_affinity_enabled = var.client_affinity_enabled
  https_only              = var.https_only

  dynamic "identity" {
    for_each = var.identity[*]
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "storage_account" {
    for_each = var.mount_points
    content {
      name         = lookup(storage_account.value, "name", format("%s-%s", storage_account.value["account_name"], storage_account.value["share_name"]))
      type         = lookup(storage_account.value, "type", "AzureFiles")
      account_name = lookup(storage_account.value, "account_name", null)
      share_name   = lookup(storage_account.value, "share_name", null)
      access_key   = lookup(storage_account.value, "access_key", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  dynamic "logs" {
    for_each = var.app_service_logs == null ? [] : [var.app_service_logs]
    content {
      detailed_error_messages = lookup(logs.value, "detailed_error_messages", null)
      failed_request_tracing  = lookup(logs.value, "failed_request_tracing", null)

      dynamic "application_logs" {
        for_each = lookup(logs.value, "application_logs", null) == null ? [] : ["application_logs"]

        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(logs.value["application_logs"], "azure_blob_storage", null) == null ? [] : ["azure_blob_storage"]
            content {
              level             = lookup(logs.value["application_logs"]["azure_blob_storage"], "level", null)
              retention_in_days = lookup(logs.value["application_logs"]["azure_blob_storage"], "retention_in_days", null)
              sas_url           = lookup(logs.value["application_logs"]["azure_blob_storage"], "sas_url", null)
            }
          }
          file_system_level = lookup(logs.value["application_logs"], "file_system_level", null)
        }
      }

      dynamic "http_logs" {
        for_each = lookup(logs.value, "http_logs", null) == null ? [] : ["http_logs"]
        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(logs.value["http_logs"], "azure_blob_storage", null) == null ? [] : ["azure_blob_storage"]
            content {
              retention_in_days = lookup(logs.value["http_logs"]["azure_blob_storage"], "retention_in_days", null)
              sas_url           = lookup(logs.value["http_logs"]["azure_blob_storage"], "sas_url", null)
            }
          }
          dynamic "file_system" {
            for_each = lookup(logs.value["http_logs"], "file_system", null) == null ? [] : ["file_system"]
            content {
              retention_in_days = lookup(logs.value["http_logs"]["file_system"], "retention_in_days", null)
              retention_in_mb   = lookup(logs.value["http_logs"]["file_system"], "retention_in_mb", null)
            }
          }
        }
      }
    }
  }

  tags = module.labels.tags

  lifecycle {
    ignore_changes = [
      app_settings, 
      site_config.0.application_stack,
      site_config.0.cors,
      site_config.0.ip_restriction_default_action,
      site_config.0.scm_ip_restriction_default_action,
      site_config.0.ftps_state
    ]
  }
}

#------------------------------App insights-------------------------------------------------------#

data "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = split("/", var.application_insights_id)[8]
  resource_group_name = split("/", var.application_insights_id)[4]
}

resource "azurerm_application_insights" "app_insights" {
  count = var.enable && var.application_insights_enabled && var.application_insights_id == null ? 1 : 0

  name                = format("%s-app-insights", module.labels.id)
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights_type
  sampling_percentage = var.application_insights_sampling_percentage
  retention_in_days   = var.retention_in_days
  disable_ip_masking  = var.disable_ip_masking
  tags                = module.labels.tags
  workspace_id        = var.app_insights_workspace_id  # Added log analytics workspace id from module in main using this variable app_insights_workspace_id 
}

#----------------------------End point ---------------------------------------------------#

resource "azurerm_private_endpoint" "pep" {
  count               = var.enable && var.enable_private_endpoint ? 1 : 0
  name                = format("%s-pe-app-service", module.labels.id)
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.subnet_id
  tags                = module.labels.tags
  private_service_connection {
    name                           = format("%s-psc-app-service", module.labels.id)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.main[0].id
    subresource_names              = ["sites"]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

data "azurerm_private_endpoint_connection" "private-ip-0" {
  count               = var.enable && var.enable_private_endpoint ? 1 : 0
  name                = join("", azurerm_private_endpoint.pep.*.name)
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_linux_web_app.main]
}

#---------------------------- Dns Zone ---------------------------------------------------#

resource "azurerm_private_dns_zone" "dnszone" {
  count               = var.enable && var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.azurewebsites.net"
  resource_group_name = local.resource_group_name
  tags                = module.labels.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vent-link" {
  count                 = var.enable && var.enable_private_endpoint && (var.existing_private_dns_zone != null ? (var.existing_private_dns_zone_resource_group_name == "" ? false : true) : true) ? 1 : 0
  name                  = var.existing_private_dns_zone == null ? format("%s-pdz-vnet-link-app-service", module.labels.id) : format("%s-pdz-vnet-link-app-service-1", module.labels.id)
  resource_group_name   = local.valid_rg_name
  private_dns_zone_name = local.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  tags                  = module.labels.tags
}

#-------------------------- Telemetry --------------------------------------#

resource "azurerm_application_insights_api_key" "read_telemetry" {
  name                    = format("%s-app-insights-api-key", module.labels.id)
  application_insights_id = azurerm_application_insights.app_insights[0].id
  read_permissions        = var.read_permissions
}

#---------------------------- Vnet Integration ---------------------------------------------------#

resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  count          = var.enable_vnet_integration == true ? 1 : 0
  app_service_id = azurerm_linux_web_app.main[0].id
  subnet_id      = var.integration_subnet_id
}

#---------------------------- Diagnostic Settings ---------------------------------------------------#

resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  count                          = var.enable && var.enable_diagnostic ? 1 : 0
  name                           = format("%s-diagnostic-log", module.labels.id)
  target_resource_id             = var.enable && var.is_linux_webapp ? azurerm_linux_web_app.main[0].id : azurerm_windows_web_app.main[0].id # Added condition for both linux and windows 
  log_analytics_workspace_id     = var.log_analytics_workspace_id 
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_destination_type = var.log_analytics_destination_type
  dynamic "enabled_log" {
    for_each = var.log_category
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.metric_enabled ? ["AllMetrics"] : []
    content {
      category = metric.value
      enabled  = true
    }
  }
}


#------------------------------------------------------------- Windows Web App ------------------------------------------------------------------------------------#

resource "azurerm_windows_web_app" "main" {
  count               = var.enable && var.is_linux_webapp ? 0 : 1
  name                = format("%s-windows-app", module.labels.id)
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main[0].id

  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.app_service_vnet_integration_subnet_id

  dynamic "site_config" {
    for_each = [local.site_config]

    content {
      windows_fx_version = lookup(site_config.value, "windows_fx_version", null) # --> Added
      container_registry_managed_identity_client_id = lookup(site_config.value, "container_registry_managed_identity_client_id", null)
      container_registry_use_managed_identity       = lookup(site_config.value, "container_registry_use_managed_identity", null)

      always_on                = lookup(site_config.value, "always_on", null)
      app_command_line         = lookup(site_config.value, "app_command_line", null)
      default_documents        = lookup(site_config.value, "default_documents", null)
      ftps_state               = lookup(site_config.value, "ftps_state", "FtpsOnly")
      health_check_path        = lookup(site_config.value, "health_check_path", null)
      http2_enabled            = lookup(site_config.value, "http2_enabled", null)
      local_mysql_enabled      = lookup(site_config.value, "local_mysql_enabled", false)
      managed_pipeline_mode    = lookup(site_config.value, "managed_pipeline_mode", null)
      minimum_tls_version      = lookup(site_config.value, "minimum_tls_version", lookup(site_config.value, "min_tls_version", "1.2"))
      remote_debugging_enabled = lookup(site_config.value, "remote_debugging_enabled", false)
      remote_debugging_version = lookup(site_config.value, "remote_debugging_version", null)
      use_32_bit_worker        = lookup(site_config.value, "use_32_bit_worker", false)
      websockets_enabled       = lookup(site_config.value, "websockets_enabled", false)

      dynamic "ip_restriction" {
        for_each = concat(local.subnets, local.cidrs, local.service_tags)
        content {
          name                      = ip_restriction.value.name
          ip_address                = ip_restriction.value.ip_address
          virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
          service_tag               = ip_restriction.value.service_tag
          priority                  = ip_restriction.value.priority
          action                    = ip_restriction.value.action
          headers                   = ip_restriction.value.headers
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
        content {
          name                      = scm_ip_restriction.value.name
          ip_address                = scm_ip_restriction.value.ip_address
          virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
          service_tag               = scm_ip_restriction.value.service_tag
          priority                  = scm_ip_restriction.value.priority
          action                    = scm_ip_restriction.value.action
          headers                   = scm_ip_restriction.value.headers
        }
      }

      # scm_type                    = lookup(site_config.value, "scm_type", null)
      scm_minimum_tls_version     = lookup(site_config.value, "scm_minimum_tls_version", "1.2")
      scm_use_main_ip_restriction = length(var.scm_authorized_ips) > 0 || var.scm_authorized_subnet_ids != null ? false : true

      vnet_route_all_enabled = var.app_service_vnet_integration_subnet_id != null

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          current_stack                = lookup(local.site_config.application_stack, "current_stack", null)
          dotnet_version               = lookup(local.site_config.application_stack, "dotnet_version", null)
          dotnet_core_version          = lookup(local.site_config.application_stack, "dotnet_core_version", null)
          tomcat_version               = lookup(local.site_config.application_stack, "tomcat_version", null)
          java_embedded_server_enabled = lookup(local.site_config.application_stack, "java_embedded_server_enabled", false)
          java_version                 = lookup(local.site_config.application_stack, "java_version", null)
          node_version                 = lookup(local.site_config.application_stack, "node_version", null)
          php_version                  = lookup(local.site_config.application_stack, "php_version", null)
          python                       = lookup(local.site_config.application_stack, "python", false) || lookup(local.site_config.application_stack, "python_version", null) != null
        }
      }

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", [])
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
    }
  }

  app_settings = var.staging_slot_custom_app_settings == null ? local.app_settings : merge(local.default_app_settings, var.staging_slot_custom_app_settings)

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }


  dynamic "auth_settings" {
    for_each = local.auth_settings.enabled ? ["enabled"] : []
    content {
      enabled                        = local.auth_settings.enabled
      issuer                         = local.auth_settings.issuer
      token_store_enabled            = local.auth_settings.token_store_enabled
      unauthenticated_client_action  = local.auth_settings.unauthenticated_client_action
      default_provider               = local.auth_settings.default_provider
      allowed_external_redirect_urls = local.auth_settings.allowed_external_redirect_urls

      dynamic "active_directory" {
        for_each = local.auth_settings_active_directory.client_id == null ? [] : [local.auth_settings_active_directory]
        content {
          client_id         = local.auth_settings_active_directory.client_id
          client_secret     = local.auth_settings_active_directory.client_secret
          allowed_audiences = concat(formatlist("https://%s", [format("%s.azurewebsites.net", format("%s-app", module.labels.id))]), local.auth_settings_active_directory.allowed_audiences)
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = lookup(var.auth_settings_v2, "auth_enabled", false) ? [var.auth_settings_v2] : []
    content {
      auth_enabled                            = lookup(auth_settings_v2.value, "auth_enabled", false)
      runtime_version                         = lookup(auth_settings_v2.value, "runtime_version", "~1")
      config_file_path                        = lookup(auth_settings_v2.value, "config_file_path", null)
      require_authentication                  = lookup(auth_settings_v2.value, "require_authentication", null)
      unauthenticated_action                  = lookup(auth_settings_v2.value, "unauthenticated_action", "RedirectToLoginPage")
      default_provider                        = lookup(auth_settings_v2.value, "default_provider", "azureactivedirectory")
      excluded_paths                          = lookup(auth_settings_v2.value, "excluded_paths", null)
      require_https                           = lookup(auth_settings_v2.value, "require_https", true)
      http_route_api_prefix                   = lookup(auth_settings_v2.value, "http_route_api_prefix", "/.auth")
      forward_proxy_convention                = lookup(auth_settings_v2.value, "forward_proxy_convention", "ForwardProxyConventionNoProxy")
      forward_proxy_custom_host_header_name   = lookup(auth_settings_v2.value, "forward_proxy_custom_host_header_name", null)
      forward_proxy_custom_scheme_header_name = lookup(auth_settings_v2.value, "forward_proxy_custom_scheme_header_name", null)

      dynamic "apple_v2" {
        for_each = try(var.auth_settings_v2.apple_v2[*], [])
        content {
          client_id                  = lookup(apple_v2.value, "client_id", null)
          client_secret_setting_name = lookup(apple_v2.value, "client_secret_setting_name", null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = try(var.auth_settings_v2.active_directory_v2[*], [])

        content {
          client_id                            = lookup(active_directory_v2.value, "client_id", null)
          tenant_auth_endpoint                 = lookup(active_directory_v2.value, "tenant_auth_endpoint", null)
          client_secret_setting_name           = lookup(active_directory_v2.value, "client_secret_setting_name", null)
          client_secret_certificate_thumbprint = lookup(active_directory_v2.value, "client_secret_certificate_thumbprint", null)
          jwt_allowed_groups                   = lookup(active_directory_v2.value, "jwt_allowed_groups", null)
          jwt_allowed_client_applications      = lookup(active_directory_v2.value, "jwt_allowed_client_applications", null)
          www_authentication_disabled          = lookup(active_directory_v2.value, "www_authentication_disabled", false)
          allowed_groups                       = lookup(active_directory_v2.value, "allowed_groups", null)
          allowed_identities                   = lookup(active_directory_v2.value, "allowed_identities", null)
          allowed_applications                 = lookup(active_directory_v2.value, "allowed_applications", null)
          login_parameters                     = lookup(active_directory_v2.value, "login_parameters", null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = try(var.auth_settings_v2.azure_static_web_app_v2[*], [])
        content {
          client_id = lookup(azure_static_web_app_v2.value, "client_id", null)
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(var.auth_settings_v2.custom_oidc_v2[*], [])
        content {
          name                          = lookup(custom_oidc_v2.value, "name", null)
          client_id                     = lookup(custom_oidc_v2.value, "client_id", null)
          openid_configuration_endpoint = lookup(custom_oidc_v2.value, "openid_configuration_endpoint", null)
          name_claim_type               = lookup(custom_oidc_v2.value, "name_claim_type", null)
          scopes                        = lookup(custom_oidc_v2.value, "scopes", null)
          client_credential_method      = lookup(custom_oidc_v2.value, "client_credential_method", null)
          client_secret_setting_name    = lookup(custom_oidc_v2.value, "client_secret_setting_name", null)
          authorisation_endpoint        = lookup(custom_oidc_v2.value, "authorisation_endpoint", null)
          token_endpoint                = lookup(custom_oidc_v2.value, "token_endpoint", null)
          issuer_endpoint               = lookup(custom_oidc_v2.value, "issuer_endpoint", null)
          certification_uri             = lookup(custom_oidc_v2.value, "certification_uri", null)
        }
      }

      dynamic "facebook_v2" {
        for_each = try(var.auth_settings_v2.facebook_v2[*], [])
        content {
          app_id                  = lookup(facebook_v2.value, "app_id", null)
          app_secret_setting_name = lookup(facebook_v2.value, "app_secret_setting_name", null)
          graph_api_version       = lookup(facebook_v2.value, "graph_api_version", null)
          login_scopes            = lookup(facebook_v2.value, "login_scopes", null)
        }
      }

      dynamic "github_v2" {
        for_each = try(var.auth_settings_v2.github_v2[*], [])
        content {
          client_id                  = lookup(github_v2.value, "client_id", null)
          client_secret_setting_name = lookup(github_v2.value, "client_secret_setting_name", null)
          login_scopes               = lookup(github_v2.value, "login_scopes", null)
        }
      }

      dynamic "google_v2" {
        for_each = try(var.auth_settings_v2.google_v2[*], [])
        content {
          client_id                  = lookup(google_v2.value, "client_id", null)
          client_secret_setting_name = lookup(google_v2.value, "client_secret_setting_name", null)
          allowed_audiences          = lookup(google_v2.value, "allowed_audiences", null)
          login_scopes               = lookup(google_v2.value, "login_scopes", null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = try(var.auth_settings_v2.microsoft_v2[*], [])
        content {
          client_id                  = lookup(microsoft_v2.value, "client_id", null)
          client_secret_setting_name = lookup(microsoft_v2.value, "client_secret_setting_name", null)
          allowed_audiences          = lookup(microsoft_v2.value, "allowed_audiences", null)
          login_scopes               = lookup(microsoft_v2.value, "login_scopes", null)
        }
      }

      dynamic "twitter_v2" {
        for_each = try(var.auth_settings_v2.twitter_v2[*], [])
        content {
          consumer_key                 = lookup(twitter_v2.value, "consumer_key", null)
          consumer_secret_setting_name = lookup(twitter_v2.value, "consumer_secret_setting_name", null)
        }
      }

      login {
        logout_endpoint                   = lookup(local.auth_settings_v2_login, "logout_endpoint", null)
        cookie_expiration_convention      = lookup(local.auth_settings_v2_login, "cookie_expiration_convention", "FixedTime")
        cookie_expiration_time            = lookup(local.auth_settings_v2_login, "cookie_expiration_time", "08:00:00")
        preserve_url_fragments_for_logins = lookup(local.auth_settings_v2_login, "preserve_url_fragments_for_logins", false)
        token_refresh_extension_time      = lookup(local.auth_settings_v2_login, "token_refresh_extension_time", 72)
        token_store_enabled               = lookup(local.auth_settings_v2_login, "token_store_enabled", false)
        token_store_path                  = lookup(local.auth_settings_v2_login, "token_store_path", null)
        token_store_sas_setting_name      = lookup(local.auth_settings_v2_login, "token_store_sas_setting_name", null)
        validate_nonce                    = lookup(local.auth_settings_v2_login, "validate_nonce", true)
        nonce_expiration_time             = lookup(local.auth_settings_v2_login, "nonce_expiration_time", "00:05:00")
      }
    }
  }

  client_affinity_enabled = var.client_affinity_enabled
  https_only              = var.https_only

  dynamic "identity" {
    for_each = var.identity[*]
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "storage_account" {
    for_each = var.mount_points
    content {
      name         = lookup(storage_account.value, "name", format("%s-%s", storage_account.value["account_name"], storage_account.value["share_name"]))
      type         = lookup(storage_account.value, "type", "AzureFiles")
      account_name = lookup(storage_account.value, "account_name", null)
      share_name   = lookup(storage_account.value, "share_name", null)
      access_key   = lookup(storage_account.value, "access_key", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  dynamic "logs" {
    for_each = var.app_service_logs == null ? [] : [var.app_service_logs]
    content {
      detailed_error_messages = lookup(logs.value, "detailed_error_messages", null)
      failed_request_tracing  = lookup(logs.value, "failed_request_tracing", null)

      dynamic "application_logs" {
        for_each = lookup(logs.value, "application_logs", null) == null ? [] : ["application_logs"]

        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(logs.value["application_logs"], "azure_blob_storage", null) == null ? [] : ["azure_blob_storage"]
            content {
              level             = lookup(logs.value["application_logs"]["azure_blob_storage"], "level", null)
              retention_in_days = lookup(logs.value["application_logs"]["azure_blob_storage"], "retention_in_days", null)
              sas_url           = lookup(logs.value["application_logs"]["azure_blob_storage"], "sas_url", null)
            }
          }
          file_system_level = lookup(logs.value["application_logs"], "file_system_level", null)
        }
      }

      dynamic "http_logs" {
        for_each = lookup(logs.value, "http_logs", null) == null ? [] : ["http_logs"]
        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(logs.value["http_logs"], "azure_blob_storage", null) == null ? [] : ["azure_blob_storage"]
            content {
              retention_in_days = lookup(logs.value["http_logs"]["azure_blob_storage"], "retention_in_days", null)
              sas_url           = lookup(logs.value["http_logs"]["azure_blob_storage"], "sas_url", null)
            }
          }
          dynamic "file_system" {
            for_each = lookup(logs.value["http_logs"], "file_system", null) == null ? [] : ["file_system"]
            content {
              retention_in_days = lookup(logs.value["http_logs"]["file_system"], "retention_in_days", null)
              retention_in_mb   = lookup(logs.value["http_logs"]["file_system"], "retention_in_mb", null)
            }
          }
        }
      }
    }
  }

  tags = module.labels.tags

  lifecycle {
    ignore_changes = [
      app_settings, 
      site_config.0.application_stack,
      site_config.0.cors,
      site_config.0.ip_restriction_default_action,
      site_config.0.scm_ip_restriction_default_action,
      site_config.0.ftps_state
    ]
  }
}

