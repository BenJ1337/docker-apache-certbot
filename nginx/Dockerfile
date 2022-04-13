FROM nginx as tmplt
ARG DOMAIN

RUN set -eux; \
    apt update && \
    apt install -y openssl && \
    rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /etc/tls/certs/nginx/live/${DOMAIN}/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/tls/certs/nginx/live/${DOMAIN}/privkey.pem \
    -out /etc/tls/certs/nginx/live/${DOMAIN}/fullchain.pem \
    -subj "/CN=$DOMAIN"

FROM nginx as nginx-proxy-certbot
ARG HTTPD_USER
ARG DOMAIN

RUN mkdir -p /etc/tls/certs/nginx/live/${DOMAIN}/
COPY --from=tmplt /etc/tls/certs/nginx/live/${DOMAIN}/privkey.pem /etc/tls/certs/nginx/live/${DOMAIN}/privkey.pem
COPY --from=tmplt /etc/tls/certs/nginx/live/${DOMAIN}/fullchain.pem /etc/tls/certs/nginx/live/${DOMAIN}/fullchain.pem

RUN groupadd -g 1000 "$HTTPD_USER"; \
    useradd "$HTTPD_USER" -u 1000 -g 1000 -m -s /bin/bash

RUN mkdir -p /var/www/html/; \
    chown "$HTTPD_USER:$HTTPD_USER" -R /var/www/