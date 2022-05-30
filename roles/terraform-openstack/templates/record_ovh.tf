
resource "ovh_domain_zone_record" "{{name}}" {
  zone      = "{{zone}}"
  subdomain = "{{subdomain}}"
  fieldtype = "{{fieldtype}}"
  ttl =  "{{ttl}}"
  target    = "{{target}}"
}