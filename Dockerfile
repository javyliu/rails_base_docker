FROM ruby:alpine
MAINTAINER javy_liu@163.com

ARG rails_root=/app

ARG build_package="build-base\
                  curl-dev \
                  git"


ARG dev_packages="postgresql-dev \
                 yaml-dev \
                 zlib-dev \
                 nodejs \
                 yarn \
                 imagemagick"

ARG ruby_packages="tzdata"

ENV BUNDLE_APP_CONFIG=$rails_root/.bundle


RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $build_package $dev_packages $ruby_packages

# no home, no passwd, no description
RUN adduser -D -u1000 -g "" -s /bin/sh vagrant vagrant

WORKDIR $rails_root
RUN chown -R vagrant:vagrant /app

USER vagrant
COPY --chown=vagrant:vagrant Gemfile* ./

RUN bundle config disable_platform_warnings true \
    #&& bundle config set --local  path 'vendor/bundle' \
    && bundle check || bundle install

COPY --chown=vagrant:vagrant . ./

ENTRYPOINT ["sh","./entrypoint.sh"]

EXPOSE 3001

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3001"]



