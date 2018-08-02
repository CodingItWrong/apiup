FROM ruby:2.5.1

RUN apt-get update
RUN apt-get install -y nodejs
RUN gem install nokogiri -v 1.8.4

RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY . /myapp

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

EXPOSE 3000

CMD bin/docker-start
