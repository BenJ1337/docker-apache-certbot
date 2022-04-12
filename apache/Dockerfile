FROM httpd:2.4 as tmplt
ARG DOMAIN
RUN set -eux; \
    apt update && \
    apt install -y openssl && \
    rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/share/TLS
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /usr/share/TLS/privkey.pem \
    -out /usr/share/TLS/fullchain.pem \
    -subj "/CN=$DOMAIN"


FROM httpd:2.4 as httpd-proxy-certbot
ARG HTTPD_USER

COPY --from=tmplt /usr/share/TLS/privkey.pem /usr/local/apache2/TLS/privkey.pem
COPY --from=tmplt /usr/share/TLS/fullchain.pem /usr/local/apache2/TLS/fullchain.pem

#COPY httpd-conf/httpd-xtra.conf /usr/local/apache2/conf/extra/httpd-xtra.conf
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /usr/local/apache2/TLS/

#COPY certbot-proxy.conf /usr/local/apache2/conf/extra/certbot-proxy.conf
#RUN echo "Include conf/extra/certbot-proxy.conf" >> /usr/local/apache2/conf/httpd.conf;

RUN groupadd -g 1000 "$HTTPD_USER"; \
    useradd "$HTTPD_USER" -u 1000 -g 1000 -m -s /bin/bash

RUN mkdir -p /var/www/html/; \
    chown "$HTTPD_USER:$HTTPD_USER" -R /var/www/

#WORKINGDIR /var/www/html/
