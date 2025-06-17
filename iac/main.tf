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
    app_settings = {
      WEBSITES_PORT = "8080"
    }
    always_on = true
  }

  container_settings {
    image_name          = "githubiacregistry.azurecr.io/myapp:latest"
    registry_server_url = "https://githubiacregistry.azurecr.io"
    registry_username   = var.docker_username
    registry_password   = var.docker_password
  }
}

output "app_url" {
  value = azurerm_linux_web_app.app.default_hostname
}
