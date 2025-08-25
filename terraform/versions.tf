# terraform/versions.tf
# ALWAYS CREATE THIS FILE FIRST
# This defines the tools and versions we're using

terraform {
  # Minimum Terraform version required
  required_version = ">= 1.0"
  
  # Required providers with version constraints
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Accept 3.x versions, but not 4.x
    }
  }
}

# Configure the Azure Provider - Minimal, Compatible Configuration
provider "azurerm" {
  # Enable Azure Resource Manager features
  features {
    # Allow deletion of resource groups that contain resources
    # This is helpful for demo/dev environments
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}