#!/bin/sh

bundle exec rake db:create
bundle exec rake db:migrate
bin/webpack-dev-server &
bundle exec puma
