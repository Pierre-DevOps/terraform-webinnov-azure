# Génération d'un suffixe aléatoire pour les noms de ressources
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Définition du suffixe pour les noms de ressources
locals {
  resource_suffix = var.resource_name_suffix != "" ? var.resource_name_suffix : random_string.suffix.result
  resource_prefix = "-"
  full_name       = "-"
}

# Resource Group principal
resource "azurerm_resource_group" "main" {
  name     = "rg-"
  location = var.azure_region
  tags     = var.common_tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space
  tags                = var.common_tags
}

# Subnet pour App Service
resource "azurerm_subnet" "app" {
  name                 = "subnet-app-"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_app_cidr]

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Subnet pour PostgreSQL
resource "azurerm_subnet" "db" {
  name                 = "subnet-db-"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_db_cidr]

  delegation {
    name = "postgresql-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Network Security Group pour App Service
resource "azurerm_network_security_group" "app" {
  name                = "nsg-app-"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.common_tags

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-app-service-outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Association NSG avec subnet app
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}
