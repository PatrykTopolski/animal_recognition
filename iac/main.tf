terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-github-iac"
  location = var.region
}

resource "azurerm_storage_account" "storage" {
  name                     = "iacstorage${random_id.rand.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "asp" {
  name                = "github-iac-asp"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_app_service" "app" {
  name                = "github-iac-webapp"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.asp.id
}
