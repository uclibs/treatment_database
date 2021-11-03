#!/bin/bash
set -e
# Note: This file is used to run commands at the start of a Docker container initialization
FILE=/app/README.md

cd /app
bundle install
# Check to see if application files are present
if test -f "$FILE"; then
    RAILS_ENV=development bundle exec rails db:migrate db:seed
fi

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"