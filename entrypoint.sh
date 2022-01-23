#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.

if [ -f /rails-app/tmp/pids/server.pid ]; then
  rm /rails-app/tmp/pids/server.pid
fi

bundle install

# wait for MySQL

until nc -vz db 3306 > /dev/null; do
    >&2 echo "MySQL:3306 is not ready, sleeping..."
    sleep 1
  done
  >&2 echo "MySQL is ready."
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup

# wait for Elasticsearch

until nc -vz elasticsearch 9200; do
  >&2 echo "Elasticsearch is not ready, sleeping..."
  sleep 1
done
>&2 echo "Elasticsearch is ready."
bundle exec rails runner "Message.import(force: true)"
>&2 echo "Docker is up!!"

exec "$@"
