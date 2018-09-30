FROM nginx

RUN apt-get update -qq && apt-get -y install apache2-utils

ARG APP_DOMAIN=www.example.com
ARG APP_PORT=3000
ARG APP_PATH=/app

ENV APP_PATH $APP_PATH
ENV APP_PORT $APP_PORT
ENV APP_DOMAIN $APP_DOMAIN

WORKDIR $APP_PATH

RUN mkdir $APP_PATH/log && touch $APP_PATH/log/nginx.access.log && touch $APP_PATH/log/nginx.error.log

COPY public public/

COPY docker/nginx/nginx.conf /tmp/docker.nginx

RUN envsubst '$APP_PATH $APP_DOMAIN $APP_PORT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]
