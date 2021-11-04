#!/bin/bash
set -e
# Note: This file is used to run commands at the start of a Docker container initialization
FILE=/treatment_database/README.md
DEVELOP="develop"
PRODUCTION="production"

cd /treatment_database

# Check to see if application files are present and in develop mode
if [ -e "$FILE" ] && [ "$MODE" == "$DEVELOP" ]; then
    echo "Found files and is in develop mode."
    bundle install
    RAILS_ENV=development bundle exec rails db:migrate db:seed
# Checks for production mode (standalone)
elif [ "$MODE" == "$PRODUCTION" ]; then
    echo "Setting up for production mode."
    cd ..
    rm -rf treatment_database
    git clone https://github.com/uclibs/treatment_database.git
    cd treatment_database
    bundle install
    RAILS_ENV=development bundle exec rails db:migrate db:seed
else
    bundle install
fi

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"