# output "service_plan_id" {
#   value       = azurerm_service_plan.main.id
#   description = "The ID of the App Service Plan component."
# }

# output "maximum_number_of_workers" {
#   value       = azurerm_service_plan.main.worker_count
#   description = "The maximum number of workers supported with the App Service Plan's sku."
# }

# output "id" {
#   value       = azurerm_linux_web_app.main[0].id
#   description = "The ID of the App Service."
# }

# output "custom_domain_verification_id" {
#   value       = azurerm_linux_web_app.main[0].custom_domain_verification_id
#   description = "An identifier used by App Service to perform domain ownership verification via DNS TXT record."
# }

# output "default_site_hostname" {
#   value       = azurerm_linux_web_app.main[0].default_hostname
#   description = "The Default Hostname associated with the App Service - such as mysite.azurewebsites.net"
# }

# output "outbound_ip_addresses" {
#   value       = azurerm_linux_web_app.main[0].outbound_ip_addresses
#   description = "A comma separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12"
# }

# output "outbound_ip_address_list" {
#   value       = join("", azurerm_linux_web_app.main[0].outbound_ip_address_list)
#   description = "A list of outbound IP addresses - such as ['52.23.25.3', '52.143.43.12']"
# }

# output "possible_outbound_ip_addresses" {
#   value       = azurerm_linux_web_app.main[0].possible_outbound_ip_addresses
#   description = "A comma separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12,52.143.43.17 - not all of which are necessarily in use. Superset of outbound_ip_addresses"
# }

# output "possible_outbound_ip_address_list" {
#   value       = join("", azurerm_linux_web_app.main[0].possible_outbound_ip_address_list)
#   description = "A list of outbound IP addresses - such as ['52.23.25.3', '52.143.43.12', '52.143.43.17'] - not all of which are necessarily in use. Superset of outbound_ip_address_list"
# }

# # output "source_control" {
# #   value       = azurerm_linux_web_app.main[0].source_control
# #   description = "A source_control block as defined below, which contains the Source Control information when scm_type is set to LocalGit."
# # }

# output "site_credential" {
#   value       = azurerm_linux_web_app.main[0].site_credential
#   description = "A site_credential block as defined below, which contains the site-level credentials used to publish to this App Service."
# }

output "service_plan_id" {
  description = "The ID of the App Service Plan component."
  value       = azurerm_service_plan.main[*].id
}

output "service_plan_name" {
  description = "The Name of the App Service Plan component."
  value       = azurerm_service_plan.main[*].name
}

output "service_plan_location" {
  description = "Azure location of the created Service Plan"
  value       = azurerm_service_plan.main[*].location
}

output "app_service_id" {
  description = "Id of the App Service"
  value       = azurerm_linux_web_app.main[*].id
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.main[*].name
}

output "app_service_default_site_hostname" {
  description = "The Default Hostname associated with the App Service"
  value       = azurerm_linux_web_app.main[*].default_hostname
}

output "app_service_outbound_ip_addresses" {
  description = "Outbound IP adresses of the App Service"
  value       = join("", azurerm_linux_web_app.main[*].outbound_ip_addresses)
}

output "app_service_possible_outbound_ip_addresses" {
  description = "Possible outbound IP adresses of the App Service"
  value       = join("", azurerm_linux_web_app.main[*].possible_outbound_ip_addresses)
}

output "app_service_site_credential" {
  description = "Site credential block of the App Service"
  value       = azurerm_linux_web_app.main[*].site_credential
}
