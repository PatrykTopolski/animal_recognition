variable "region" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "West Europe"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure client ID (App ID)"
  type        = string
}

variable "client_secret" {
  description = "Azure client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "azure_storage_connection_string" {
  type = string
  description = "Connection string do Azure Storage"
}
