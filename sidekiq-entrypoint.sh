#!/bin/sh

set -e
if [ -f tmp/pids/sidekiq.pid ]; then
  rm tmp/pids/sidekiq.pid
fi

bundle exec sidekiq
