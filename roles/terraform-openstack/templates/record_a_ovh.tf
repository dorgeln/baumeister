
resource "ovh_domain_zone_record" "{{name}}" {
  zone      = "{{domain}}"
  subdomain = "{{hostname}}"
  fieldtype = "A"
  ttl = "60"
  target    = "${openstack_compute_instance_v2.{{hostname}}.network[0].fixed_ip_v4}"
}