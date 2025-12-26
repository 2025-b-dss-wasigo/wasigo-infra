variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "eastus"
}

variable "project" {
  description = "Nombre del proyecto"
  type        = string
  default     = "wasigo"
}

variable "environment" {
  description = "Entorno"
  type        = string
  default     = "dev"
}
