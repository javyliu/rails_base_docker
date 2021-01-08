FROM  ruby:alpine as build-env

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev nodejs yarn"
#ARG DEV_PACKAGES="sqlite-dev yaml-dev zlib-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata"

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"


WORKDIR $RAILS_ROOT

#install packages

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache  $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES
    #&& gem update --system

COPY Gemfile* package.json yarn.lock ./

#install rubygem

# &&bundle lock --add-platform x86_64-linux-musl

RUN bundle config --global frozen 1 \
    && bundle config disable_platform_warnings true \
    && bundle config set --local path 'vendor/bundle' \
    && bundle config set --local without 'development:test:assets'\
    #&& bundle lock --add-platform x86_64-linux-musl \
    && bundle install -j4 --retry 3 \
    #--path=vendor/bundle --without=development:test:assets \
    && rm -rf vendor/bundle/ruby/3.0.0/cache/*.gem \
    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.o" -delete

RUN yarn install --production
COPY . .

#if use webpacker
RUN bin/rails webpacker:compile
RUN bin/rails assets:precompile

RUN rm -rf node_modules tmp/cache  vendor/assets spec


##########build step done ##########

FROM ruby:alpine
ARG RAILS_ROOT=/app
ARG PACKAGES="tzdata postgresql-client nodejs"
#ARG PACKAGES="tzdata sqlite-dev nodejs>10"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"
ENV RAILS_SERVE_STATIC_FILES="yes"

WORKDIR $RAILS_ROOT

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache  $PACKAGES

COPY --from=build-env $RAILS_ROOT $RAILS_ROOT
EXPOSE 3001

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
