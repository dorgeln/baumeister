variable "ovh_endpoint" {
    type        = string
    default = "https://eu.api.ovh.com"
}

variable "ovh_application_key" {
    type        = string
    sensitive = true
}

variable "ovh_application_secret" {
    type        = string
    sensitive = true
}

variable "ovh_consumer_key" {
    type        = string
    sensitive = true
}

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

