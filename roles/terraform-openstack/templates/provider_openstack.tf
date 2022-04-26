
variable "os_domain_name" {
    type        = string
    default = "default"
}


variable "os_auth_url" {
    type        = string
    default = "https://auth.cloud.ovh.net/v3/"
}


variable "os_user_name" {
    type        = string
    sensitive = true
}

variable "os_tenant_id" {
    type        = string
    sensitive = true
}

variable "os_tenant_name" {
    type        = string
}

variable "os_password" {
    type        = string
    sensitive = true
}


provider "openstack" {
  auth_url    = var.os_auth_url 
  domain_name = var.os_domain_name
  tenant_id = var.os_tenant_id
  tenant_name = var.os_tenant_name
  user_name = var.os_user_name
  password = var.os_password
}

