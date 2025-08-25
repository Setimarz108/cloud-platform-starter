

# ============================================================================
# BASIC RESOURCE INFORMATION
# ============================================================================

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region where resources were deployed"
  value       = azurerm_resource_group.main.location
}

# ============================================================================
# APPLICATION ACCESS INFORMATION
# ============================================================================

output "application_url" {
  description = "Main URL where your application is accessible"
  value       = "http://${azurerm_container_group.main.fqdn}:3000"
}

output "application_fqdn" {
  description = "Fully qualified domain name of the application"
  value       = azurerm_container_group.main.fqdn
}

output "container_public_ip" {
  description = "Public IP address assigned to the container group"
  value       = azurerm_container_group.main.ip_address
}

# ============================================================================
# MONITORING AND HEALTH ENDPOINTS
# ============================================================================

output "health_check_url" {
  description = "Health check endpoint for monitoring"
  value       = "http://${azurerm_container_group.main.fqdn}:3000/health"
}

output "metrics_url" {
  description = "Metrics endpoint for observability"
  value       = "http://${azurerm_container_group.main.fqdn}:3000/metrics"
}

output "application_info_url" {
  description = "Application info endpoint for troubleshooting"
  value       = "http://${azurerm_container_group.main.fqdn}:3000/info"
}

# ============================================================================
# CONTAINER REGISTRY INFORMATION
# ============================================================================

output "container_registry_url" {
  description = "Login server URL for the container registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_name" {
  description = "Name of the container registry"
  value       = azurerm_container_registry.main.name
}

output "registry_admin_username" {
  description = "Admin username for container registry authentication"
  value       = azurerm_container_registry.main.admin_username
}

# Sensitive output - password won't be displayed in terminal
output "registry_admin_password" {
  description = "Admin password for container registry (marked as sensitive)"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true  # This prevents the password from showing in terraform output
}

# ============================================================================
# NETWORKING INFORMATION
# ============================================================================

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "virtual_network_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "container_subnet_name" {
  description = "Name of the container subnet"
  value       = azurerm_subnet.containers.name
}

output "network_security_group_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.main.name
}

# ============================================================================
# COST AND RESOURCE SUMMARY
# ============================================================================

output "cost_estimation" {
  description = "Estimated monthly cost breakdown for planning"
  value = {
    container_instances = "~$10-15/month (0.5 CPU, 1GB RAM, 730h runtime)"
    container_registry  = "~$5/month (Basic tier)"
    virtual_network     = "$0 (included in free tier)"
    network_security_group = "$0 (included in free tier)"
    public_ip          = "$0 (included with container instances)"
    total_estimated    = "~$15-20/month"
    cost_optimization_notes = [
      "Stop containers when not needed to reduce costs",
      "Container instances charge per second of runtime",
      "Registry storage costs extra beyond 10GB"
    ]
  }
}

output "resource_summary" {
  description = "Summary of all created resources"
  value = {
    resource_group     = azurerm_resource_group.main.name
    container_registry = azurerm_container_registry.main.name
    virtual_network    = azurerm_virtual_network.main.name
    container_group    = azurerm_container_group.main.name
    security_group     = azurerm_network_security_group.main.name
    total_resources    = "5 main resources + 1 subnet + 1 NSG association"
  }
}

# ============================================================================
# OPERATIONAL INFORMATION
# ============================================================================

output "deployment_commands" {
  description = "Useful commands for post-deployment operations"
  value = {
    view_logs          = "az container logs --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_container_group.main.name}"
    restart_container  = "az container restart --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_container_group.main.name}"
    check_status      = "az container show --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_container_group.main.name} --query instanceView.state"
    connect_to_registry = "az acr login --name ${azurerm_container_registry.main.name}"
  }
}

# ============================================================================
# DEVELOPMENT INFORMATION
# ============================================================================

output "docker_push_commands" {
  description = "Commands to build and push your container image"
  value = {
    login_to_registry = "az acr login --name ${azurerm_container_registry.main.name}"
    build_image      = "docker build -t ${azurerm_container_registry.main.login_server}/cloud-platform-starter:latest ."
    push_image       = "docker push ${azurerm_container_registry.main.login_server}/cloud-platform-starter:latest"
    update_container = "# Update the container_image variable and run terraform apply"
  }
}

# ============================================================================
# TROUBLESHOOTING INFORMATION
# ============================================================================

output "troubleshooting_endpoints" {
  description = "URLs for testing and debugging the application"
  value = {
    main_app     = "curl http://${azurerm_container_group.main.fqdn}:3000/"
    health_check = "curl http://${azurerm_container_group.main.fqdn}:3000/health"
    metrics      = "curl http://${azurerm_container_group.main.fqdn}:3000/metrics"
    app_info     = "curl http://${azurerm_container_group.main.fqdn}:3000/info"
    error_test   = "curl http://${azurerm_container_group.main.fqdn}:3000/error"
  }
  }

