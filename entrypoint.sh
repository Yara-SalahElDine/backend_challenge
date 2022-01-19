#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.

if [ -f /rails-app/tmp/pids/server.pid ]; then
  rm /rails-app/tmp/pids/server.pid
fi

until nc -vz db 3306 > /dev/null; do
    >&2 echo "db:3306 is unavailable - sleeping"
    sleep 1
  done
  >&2 echo "db:3306 is up"

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup

exec "$@"
