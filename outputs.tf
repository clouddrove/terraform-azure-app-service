output "service_plan_id" {
  value       = azurerm_app_service_plan.main.id
  description = "The ID of the App Service Plan component."
}

output "maximum_number_of_workers" {
  value       = azurerm_app_service_plan.main.maximum_number_of_workers
  description = "The maximum number of workers supported with the App Service Plan's sku."
}

output "id" {
  value       = azurerm_app_service.main[0].id
  description = "The ID of the App Service."
}

output "custom_domain_verification_id" {
  value       = azurerm_app_service.main[0].custom_domain_verification_id
  description = "An identifier used by App Service to perform domain ownership verification via DNS TXT record."
}

output "default_site_hostname" {
  value       = azurerm_app_service.main[0].default_site_hostname
  description = "The Default Hostname associated with the App Service - such as mysite.azurewebsites.net"
}

output "outbound_ip_addresses" {
  value       = azurerm_app_service.main[0].outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12"
}

output "outbound_ip_address_list" {
  value       = join("", azurerm_app_service.main[0].outbound_ip_address_list)
  description = "A list of outbound IP addresses - such as ['52.23.25.3', '52.143.43.12']"
}

output "possible_outbound_ip_addresses" {
  value       = azurerm_app_service.main[0].possible_outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12,52.143.43.17 - not all of which are necessarily in use. Superset of outbound_ip_addresses"
}

output "possible_outbound_ip_address_list" {
  value       = join("", azurerm_app_service.main[0].possible_outbound_ip_address_list)
  description = "A list of outbound IP addresses - such as ['52.23.25.3', '52.143.43.12', '52.143.43.17'] - not all of which are necessarily in use. Superset of outbound_ip_address_list"
}

output "source_control" {
  value       = azurerm_app_service.main[0].source_control
  description = "A source_control block as defined below, which contains the Source Control information when scm_type is set to LocalGit."
}

output "site_credential" {
  value       = azurerm_app_service.main[0].site_credential
  description = "A site_credential block as defined below, which contains the site-level credentials used to publish to this App Service."
}