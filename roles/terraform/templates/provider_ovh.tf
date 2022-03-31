variable "endpoint" {
    type        = string
    default = "https://eu.api.ovh.com"
}

variable "application_key" {
    type        = string
    sensitive = true
}

variable "application_secret" {
    type        = string
    sensitive = true
}

variable "consumer_key" {
    type        = string
    sensitive = true
}

variable "auth_url" {
    type        = string
    default = "https://auth.cloud.ovh.net/v3/"
}

variable "domain_name" {
    type        = string
    default = "default"
}

variable "user_name" {
    type        = string
    sensitive = true
}

variable "user_domain_name" {
    type        = string
    sensitive = true
}

variable "tenant_id" {
    type        = string
    sensitive = true
}

variable "tenant_name" {
    type        = string
}

variable "password" {
    type        = string
    sensitive = true
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.application_key
  application_secret = var.application_secret
  consumer_key       = var.consumer_key
}

provider "openstack" {
  auth_url    = var.auth_url # Authentication URL
  domain_name = var.domain_name # Domain name - Always at 'default' for OVHcloud
  tenant_id = var.tenant_id
  tenant_name = var.tenant_name
  user_domain_name = var.user_domain_name
  user_name = var.user_name
  password = var.password
}


