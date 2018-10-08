FROM staticfloat/nginx-certbot

RUN apt-get update -qq && apt-get -y install apache2-utils

ENV APP_PATH /app
ENV APP_PORT 3000
ENV APP_DOMAIN app.local
ENV APP_NAME app
ENV CERT_PATH "/app/docker-configs/certs/nginx-selfsigned.crt"
ENV CERT_KEY_PATH "/app/docker-configs/certs/nginx-selfsigned.key"
ENV DH_PARAM_PATH "/app/docker-configs/certs/dhparam-2048.pem"

WORKDIR $APP_PATH

COPY public public/

COPY docker/nginx/nginx.conf docker/nginx/start.sh docker-configs/
COPY docker/nginx/certs docker-configs/certs/

RUN chmod +x ./docker-configs/start.sh

EXPOSE 80
EXPOSE 443

CMD ["/bin/bash", "./docker-configs/start.sh"]

