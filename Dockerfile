ARG RUBY_VERSION=3.1.2
FROM --platform=linux/x86-64 ruby:${RUBY_VERSION}
LABEL maintainer="LUIS GIL <luis.gil@puntored.co>"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    bash build-essential tzdata git \
    libvips pkg-config libpq-dev postgresql-client

ENV APP_PATH /notifications_api
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

ENV TZ=America/Bogota
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV RAILS_ENV $RAILS_ENV
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV WEB_CONCURRENCY 2
ENV RAILS_MIN_THREADS 5
ENV RAILS_MAX_THREADS 20
ENV BUNDLER_VERSION 2.4

RUN gem install bundler -v $BUNDLER_VERSION
ADD Gemfile $APP_PATH/Gemfile
RUN echo '' > Gemfile.lock
RUN bundle install
COPY . $APP_PATH

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

EXPOSE $APP_PORT
CMD rm -f tmp/pids/server.pid && bin/rails s -p $APP_PORT -b '0.0.0.0'