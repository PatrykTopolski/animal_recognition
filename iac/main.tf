provider "azurerm" {
  features {}
}

variable "docker_username" {}
variable "docker_password" {}

data "azurerm_resource_group" "rg" {
  name = "rg-github-iac"
}

data "azurerm_service_plan" "asp" {
  name                = "github-iac-asp"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_linux_web_app" "app" {
  name                = "github-iac-webapp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = data.azurerm_service_plan.asp.id

  site_config {
    application_stack {
      docker_image_name   = "githubiacregistry.azurecr.io/myapp"
      docker_image_tag    = "latest"
      docker_registry_url = "https://githubiacregistry.azurecr.io"
    }

    always_on = true
  }

  app_settings = {
    WEBSITES_PORT                    = "8080"
    DOCKER_REGISTRY_SERVER_URL      = "https://githubiacregistry.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = var.docker_username
    DOCKER_REGISTRY_SERVER_PASSWORD = var.docker_password
  }
}

output "app_url" {
  value = azurerm_linux_web_app.app.default_hostname
}
