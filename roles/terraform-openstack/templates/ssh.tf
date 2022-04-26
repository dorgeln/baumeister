resource "openstack_compute_keypair_v2" "{{deployment}}-{{workspace}}-{{region|lower}}" {
  provider   = {{provider}} # Provider name declared in provider.tf
  region     = "{{region}}"
  name       = "{{deployment}}-{{workspace}}" # Name of the SSH key to use for creation
  public_key = file("id_rsa.pub") # Path to your previously generated SSH key
}