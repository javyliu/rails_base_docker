#!/bin/sh

set -e
echo "------exec the entrypoint.sh"
if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

#会执执在Dockfile中cmd中指定的命令
exec "$@"
