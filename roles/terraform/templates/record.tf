resource "ovh_domain_zone_record" "{{deployment}}-{{workspace}}-{{id}}-{{region|lower}}_dns_hostname" {
  zone      = "{{domain}}"
  subdomain = "{{deployment}}-{{workspace}}-{{id}}-{{region|lower}}"
  fieldtype = "A"
  target    = "${openstack_compute_instance_v2.{{deployment}}-{{workspace}}-{{id}}-{{region|lower}}.network[0].fixed_ip_v4}"
}