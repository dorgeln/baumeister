certbot certonly --force-renewal {% if staging is defined and staging is sameas true %} --test-cert{% endif %} \
    --dns-ovh --non-interactive --agree-tos \
    -m {{email}} --dns-ovh-credentials ../../../../.secrets/certbot_ovh.ini \
    --logs-dir . --dns-ovh-propagation-seconds 60 \
--cert-name baumeister \
{% for h in hostnames %}
-d {{h}}.{{domain}} \
-d {{h}}-repo.{{domain}} \
{% if 'alias' in hostvars[h] %}
-d {{hostvars[h]['alias']}}.{{domain}}  \
{% endif %}
{% if 'alias2' in hostvars[h] %}
-d {{hostvars[h]['alias2']}}.{{domain}}  \
{% endif %}
{% if 'cockpit_host' in hostvars[h] %}
-d {{hostvars[h]['cockpit_host']}}.{{domain}}  \
{% endif %}
{% if 'syncthing_host' in hostvars[h] %}
-d {{hostvars[h]['syncthing_host']}}.{{domain}} \
{% endif %}
{% if 'minimap_host' in hostvars[h] %}
-d {{hostvars[h]['minimap_host']}}.{{domain}} \
{% endif %}
{% endfor %}
--work-dir . --config-dir . --logs-dir .

