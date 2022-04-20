#!/bin/bash

# Request new certificate

export $(grep -v '^#' ../.env | xargs)

domains=()
leng=10
echo "A max of $leng domains are currently recognized."
for i in $(seq 1 $leng) 
do
    if [[ -v MY_DOMAIN_$i ]]
    then
        domain_var="MY_DOMAIN_$i"
        domain=${!domain_var}
        echo "$i. $domain"
        # Caution: you can not use CRLF (use LF instead) or you have to remove the \r at the end. When you execute "${domains[@]}" it overwrite the line written before that current entry in the array
        domains+=("-d ${domain}") 
    else
        break
    fi
done
echo "Anzahl an Domains: ${#domains[@]}"
echo "${domains[@]}"

echo "start Docker Containter with Certbot.."
docker run -it --rm \
            -v "$CERTBOT_CERTS_PATH:/etc/letsencrypt" \
            --network $CERTBOT_BACKEND_NETWORK \
            --name $CERTBOT_CONTAINER_SERVICE_NAME \
            "certbot/certbot:$CERTBOT_TAG" certonly\
            --verbose \
            --keep-until-expiring \
            --agree-tos --email $CERTBOT_EMAIL \
            --preferred-challenges http \
            --standalone \
            "${domains[@]}"
