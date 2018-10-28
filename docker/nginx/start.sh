#!/bin/sh

echo "SUBSTITUTE ENV FOR NGINX CONF ..."

if [ "$APP_ENV" == 'production' ]; then
  CERT_PATH="/etc/letsencrypt/live/$APP_DOMAIN/fullchain.pem"
  CERT_KEY_PATH="/etc/letsencrypt/live/$APP_DOMAIN/privkey.pem"

  envsubst '$APP_PATH $APP_DOMAIN $APP_PORT $CERT_PATH $CERT_KEY_PATH $DH_PARAM_PATH' < "$APP_PATH/docker-configs/nginx-production.conf" > /etc/nginx/conf.d/default.conf
  echo "STARTING NGINX with letsencrypt ..."

  /scripts/entrypoint.sh
else
  envsubst '$APP_PATH $APP_DOMAIN $APP_PORT $CERT_PATH $CERT_KEY_PATH $DH_PARAM_PATH' < "$APP_PATH/docker-configs/nginx.conf" > /etc/nginx/conf.d/default.conf
  echo "STARTING NGINX ..."

  nginx -g 'daemon off;'
fi

