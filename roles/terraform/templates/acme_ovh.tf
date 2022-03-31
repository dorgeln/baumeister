provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

# letsencrypt acme challenge
# Create the private key for the registration (not the certificate)
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# Set up a registration using a private key from tls_private_key
resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.email}"
}

# Create a certificate
resource "acme_certificate" "certificate" {
  account_key_pem = "${acme_registration.reg.account_key_pem}"
  common_name     = "${var.name}.${var.zone}"
  dns_challenge {
    provider = "ovh"
  }
}