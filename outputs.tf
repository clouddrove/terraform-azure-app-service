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

output "instrumentation_key" {
  value = azurerm_application_insights.app_insights[0].instrumentation_key
}

output "connection_string" {
  value = azurerm_application_insights.app_insights[0].connection_string
}