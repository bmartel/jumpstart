FROM bmartel/ruby:2.6-rc-base

ARG RAILS_ENV=production
ARG APP_PATH=/usr/src/app
ARG APP_DOMAIN=www.example.com

ENV RAILS_ENV $RAILS_ENV
ENV APP_PATH $APP_PATH
ENV APP_DOMAIN $APP_DOMAIN

WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock $APP_PATH/
RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

COPY . $APP_PATH/

RUN chmod +x ./docker/start.sh

RUN if [ "$RAILS_ENV" == 'production' ]; then bundle exec rails assets:precompile && rm -rf node_modules; fi

EXPOSE $PORT

CMD ./docker/start.sh
