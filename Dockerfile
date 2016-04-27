FROM ruby:2.3

RUN mkdir -p /app
RUN mkdir -p /var/shared

WORKDIR /app
ADD . /app
RUN gem install bundler && bundle install

CMD puma config.ru -C puma.rb
