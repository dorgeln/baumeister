resource "openstack_compute_instance_v2" "{{name}}" {
   name        = "{{name}}"  # Instance name
   provider    = {{provider}}  # Provider name
   region = "{{region}}"
   image_name  = "{{image}}" # Image name
   flavor_name = "{{flavour}}" # Instance type name
   metadata = {
     group = "{{group}}"
     ansible_user = "{{user}}"
     domain = "{{domain}}"
   }
   key_pair    = openstack_compute_keypair_v2.{{deployment}}-{{workspace}}-{{region|lower}}.name
   network {
    name      = "Ext-Net" 
   }
}

resource "ovh_domain_zone_record" "{{name}}_dns_hostname" {
  zone      = "{{domain}}"
  subdomain = "{{name}}"
  fieldtype = "A"
  ttl = "60"
  target    = "${openstack_compute_instance_v2.{{name}}.network[0].fixed_ip_v4}"
}
