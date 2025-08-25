# Core infrastructure resources
# Note: Provider configuration is in versions.tf

# Create a resource group - like a folder for all your resources
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Container Registry - where we'll store your Docker images
resource "azurerm_container_registry" "main" {
  name                = var.registry_name
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  sku                = "Basic"  # Cheapest tier for learning
  admin_enabled      = true     # Allows simple authentication

  tags = var.tags
}

# Virtual Network - isolated network for your resources
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]  # Private IP range
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Subnet - section of the virtual network for containers
resource "azurerm_subnet" "containers" {
  name                 = "containers"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]  # Subset of the VNet range

  # Allow Azure Container Instances to use this subnet
  delegation {
    name = "container-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Network Security Group - firewall rules
resource "azurerm_network_security_group" "main" {
  name                = "${var.project_name}-nsg"
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Allow HTTP traffic on port 3000
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS traffic (for future use)
  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate security group with subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.containers.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Container Instance - where your app will actually run
resource "azurerm_container_group" "main" {
  name                = "${var.project_name}-containers"
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type            = "Linux"
  subnet_ids         = [azurerm_subnet.containers.id]

  container {
    name   = "web"
    image  = var.container_image  # We'll update this to use your registry
    cpu    = "0.5"               # Half a CPU core (cost optimization)
    memory = "1.0"               # 1GB RAM (sufficient for Node.js)

    ports {
      port     = 3000
      protocol = "TCP"
    }

    # Environment variables for your app
    environment_variables = {
      "NODE_ENV" = var.environment
      "PORT"     = "3000"
    }
  }

  # Make container accessible from internet
  ip_address_type = "Public"
  dns_name_label  = "${var.project_name}-${var.environment}"

  tags = var.tags
}
