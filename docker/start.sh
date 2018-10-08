#!/bin/sh

if [ "$RAILS_ENV" == 'production' ]; then
  bundle exec rails assets:precompile
  rm -rf node_modules
else
  bundle exec rake db:create
  bundle exec rake db:migrate
  bin/webpack-dev-server &
fi

bundle exec puma
