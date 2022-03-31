FROM envoyproxy/envoy-dev:latest

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
COPY ./fullchain.pem /etc/fullchain.pem
COPY ./privkey.pem /etc/privkey.pem
COPY ./envoy.yaml /etc/envoy.yaml
RUN chmod go+r /etc/envoy.yaml /etc/fullchain.pem /etc/privkey.pem 
CMD ["/usr/local/bin/envoy", "-c", "/etc/envoy.yaml", "--service-cluster", "front-proxy"]
