terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    # La configuration backend sera fournie via backend-config.auto.tfvars
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  # Utilisation de l'authentification Azure CLI
  use_oidc = true
}

provider "random" {
  # Configuration par défaut
}
