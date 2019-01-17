FROM bmartel/ruby:2.6-base

WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock $APP_PATH/
RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

COPY . $APP_PATH/

RUN chmod +x ./docker/start.sh

EXPOSE $PORT

CMD ./docker/start.sh
