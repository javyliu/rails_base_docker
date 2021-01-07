FROM ruby:alpine
MAINTAINER javy_liu@163.com

ARG rails_root=/app
ARG build_package=build-base\
                  curl-dev \
                  git
ARG dev_packages=postgresql-dev \
                 yaml-dev \
                 zlib-dev \
                 nodejs \
                 yarn \
                 ImageMagick

ARG ruby_packages=tzdata

ENV BUNDLE_APP_CONFIG=$rails_root/.bundle

WORKDIR $rails_root

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $build_package $dev_packages $ruby_packages

# no home, no passwd, no description
RUN adduser -DH -u1200 -g "" -s /bin/sh vagrant vagrant
USER vagrant

COPY Gemfile* ./
RUN bundle check || bundle install
COPY . ./

ENTRYPOINT ["sh","./entrypoint.sh"]

EXPOSE 3001

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3001"]



