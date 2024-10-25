FROM ruby:2.3.8-alpine3.8

RUN apk --update add build-base nodejs tzdata mysql-dev mysql-client libxslt-dev libxml2-dev imagemagick net-tools

ENV APP_HOME /app
ENV HOME /root

RUN mkdir $APP_HOME
COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME

WORKDIR $APP_HOME

RUN gem install bundler:2.3.26 rake nokogiri:1.8.2 && \
    bundle install --full-index

COPY . $APP_HOME
RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
