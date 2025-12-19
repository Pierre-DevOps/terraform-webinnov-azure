# Variables de configuration générale
variable "azure_region" {
  description = "Région Azure où déployer les ressources"
  type        = string
  default     = "switzerlandnorth"
}

variable "environment" {
  description = "Environnement de déploiement (prod, dev, staging)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Nom du projet (utilisé pour le naming des ressources)"
  type        = string
  default     = "webinnov"
}

# Tags communs
variable "common_tags" {
  description = "Tags à appliquer à toutes les ressources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "WebInnov"
    ManagedBy   = "Terraform"
  }
}

# Configuration réseau
variable "vnet_address_space" {
  description = "Espace d'adressage du VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_app_cidr" {
  description = "CIDR du subnet pour l'application"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_db_cidr" {
  description = "CIDR du subnet pour la base de données"
  type        = string
  default     = "10.0.2.0/24"
}

# Configuration App Service
variable "app_service_plan_sku" {
  description = "SKU du App Service Plan"
  type        = string
  default     = "B2"
}

variable "python_version" {
  description = "Version de Python pour l'application"
  type        = string
  default     = "3.11"
}

# Configuration PostgreSQL
variable "postgresql_version" {
  description = "Version de PostgreSQL"
  type        = string
  default     = "15"
}

variable "postgresql_sku" {
  description = "SKU du PostgreSQL Flexible Server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgresql_storage" {
  description = "Stockage en GB pour PostgreSQL"
  type        = number
  default     = 32
}

variable "postgresql_admin_login" {
  description = "Login admin pour PostgreSQL"
  type        = string
  sensitive   = true
}

variable "postgresql_admin_password" {
  description = "Mot de passe admin pour PostgreSQL"
  type        = string
  sensitive   = true
}

# Suffixe pour les noms de ressources
variable "resource_name_suffix" {
  description = "Suffixe aléatoire pour les noms de ressources uniques"
  type        = string
  default     = ""
}
