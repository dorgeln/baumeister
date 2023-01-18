resource "openstack_compute_instance_v2" "{{name}}" {
   name        = "{{name}}"  # Instance name
   provider    = {{provider}}  # Provider name
   region = "{{region}}"
   image_name  = "{{image}}" # Image name
   flavor_name = "{{flavour}}" # Instance type name
   metadata = {
     group = "{{group}}"
     ansible_user = "{{ansible_user}}"
     domain = "{{domain}}"
     alias = "{{alias}}"
     alias2 = "{{alias2}}"
   }
   key_pair    = openstack_compute_keypair_v2.{{deployment}}-{{workspace}}-{{version_major}}-{{region|lower}}.name
   network {
    name      = "Ext-Net" 
   }
}