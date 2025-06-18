terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.81.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "rg" {
  name = "rg-github-iac"
}

data "azurerm_service_plan" "asp" {
  name                = "github-iac-asp"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "acr" {
  name                = "githubiacregistry"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_linux_web_app" "app" {
  name                = "github-iac-webapp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = data.azurerm_service_plan.asp.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = "8080"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "1800"
    WEBSITES_CONTAINER_IMAGE             = "githubiacregistry.azurecr.io/myapp:latest"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}


output "app_url" {
  value = azurerm_linux_web_app.app.default_hostname
}
