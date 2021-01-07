#!/bin/sh

set -e
echo "------exec the entrypoint.sh"
if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

exec "$@"
