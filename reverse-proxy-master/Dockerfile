FROM caddy:latest

COPY Caddyfile /etc/caddy/Caddyfile

CMD sh -c "echo -e 'nameserver host.containers.internal\nnameserver 1.1.1.1' > /etc/resolv.conf && caddy run --config /etc/caddy/Caddyfile --adapter caddyfile"
