certbot certonly --force-renewal {% if staging is defined and staging is sameas true %}--test-cert{% endif %} \
--dns-cloudflare --non-interactive --agree-tos \
-m {{email}} --dns-cloudflare-credentials  ../.secrets/cloudflare.ini \
--dns-cloudflare-propagation-seconds 60 --cert-name baumeister \
{% for h in hostnames %}
-d {{h}}.{{domain}} \
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

