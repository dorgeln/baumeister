../../../../.micromamba/envs/default/bin/certbot certonly --force-renewal {% if staging is sameas true %}--test-cert{% endif %} \
    --dns-ovh --non-interactive --agree-tos \
    -m {{email}} --dns-ovh-credentials ../../../../.secrets/ovh.ini \
    --cert-name {{fqdn}} -d {{fqdn}} \
    {% for d in aliases %}-d {{d}} {% endfor %} \
    {% for d in fqdns %}-d {{d}} {% endfor %} \
    {% for h in hostnames %}-d {{h}}.{{domain}} {% endfor %} \
    --work-dir . --config-dir . \
    --logs-dir . --dns-ovh-propagation-seconds 60 

