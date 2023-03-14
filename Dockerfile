FROM ruby:2.7.7
ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN mkdir /prospects_watcher
WORKDIR /prospects_watcher
ADD Gemfile /prospects_watcher/Gemfile
ADD Gemfile.lock /prospects_watcher/Gemfile.lock
RUN bundle install
ADD . /prospects_watcher
