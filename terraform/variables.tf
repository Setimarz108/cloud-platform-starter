
variable "project_name" {
  description = "Name of the project - used as prefix for resources"
  type        = string
  default     = "cloud-platform-starter"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}



variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
 
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}



variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
  

  # validation {
  #   condition = contains([
  #     "East US", "West US 2", "West Europe", "Southeast Asia"
  #   ], var.location)
  #   error_message = "Location should be a free tier region for cost optimization."
  # }
}



variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-cloud-platform-starter"
}



variable "registry_name" {
  description = "Name for the container registry (must be globally unique across all Azure)"
  type        = string
  default     = "cpsregistry01"  
  
 
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.registry_name))
    error_message = "Registry name must contain only lowercase letters and numbers (no hyphens or special chars)."
  }
  
  validation {
    condition     = length(var.registry_name) >= 5 && length(var.registry_name) <= 50
    error_message = "Registry name must be between 5 and 50 characters."
  }
}




variable "container_image" {
  description = "Docker image to deploy to the container instance"
  type        = string
  default     = "nginx:alpine"  # Safe default for initial deployment
}


variable "container_cpu" {
  description = "CPU allocation for the container (in CPU cores)"
  type        = string
  default     = "0.5"
  
  # Senior consideration: Validate against Azure's allowed values
  validation {
    condition = contains(["0.5", "1.0", "2.0"], var.container_cpu)
    error_message = "Container CPU must be one of: 0.5, 1.0, 2.0 (Azure Container Instances limitation)."
  }
}

variable "container_memory" {
  description = "Memory allocation for the container (in GB)"
  type        = string
  default     = "1.0"
  
  validation {
    condition = contains(["0.5", "1.0", "1.5", "2.0", "3.5", "7.0", "14.0"], var.container_memory)
    error_message = "Memory must be one of the Azure-supported values: 0.5, 1.0, 1.5, 2.0, 3.5, 7.0, 14.0 GB."
  }
}

# Why separate CPU and memory variables?
# - Different workloads have different resource needs
# - Cost optimization by right-sizing resources
# - Easy to experiment with different configurations
# - Azure has specific allowed combinations

# =============================================================================
# STEP 5: BUSINESS/OPERATIONAL VARIABLES
# Senior thinking: "What helps with management and cost tracking?"
# =============================================================================

variable "tags" {
  description = "Tags to apply to all resources for management and cost tracking"
  type        = map(string)
  default = {
    Project      = "Cloud Platform Starter"
    Environment  = "Development"  # Will be overridden by local.tags
    ManagedBy    = "Terraform"
    Purpose      = "Learning"
    Owner        = "YourName"     # TODO: Update with actual name
    CostCenter   = "Personal"
  }
}

# Why a tags variable?
# - Cost management and allocation
# - Resource organization and governance  
# - Automation and policy enforcement
# - Compliance and auditing requirements
# - Easy to customize for different organizations

# =============================================================================
# STEP 6: ADVANCED SENIOR PATTERNS
# Senior enhancement: Computed locals for complex logic
# =============================================================================

locals {
  # Merge environment into tags
  common_tags = merge(var.tags, {
    Environment = var.environment
    DeployDate  = formatdate("YYYY-MM-DD", timestamp())
  })
  
  # Computed naming with environment
  resource_group_name = "${var.project_name}-${var.environment}-rg"
  
  # Cost-aware sizing based on environment
  container_config = var.environment == "prod" ? {
    cpu    = "1.0"
    memory = "2.0"
  } : {
    cpu    = var.container_cpu
    memory = var.container_memory
  }
}

# Why use locals?
# - Complex computations don't belong in resource blocks
# - Reusable values computed once
# - Environment-specific logic centralized
# - Cleaner main.tf file