# Treatment Database

This is a web application originally developed for the Preservation Lab at the University of Cincinnati. Provided that you have Ruby on Rails and the necessary JavaScript environment installed, you can run this application on your local machine or server.

## Getting Started

To get started with the application, clone the repository and then install the required dependencies:

```bash
git clone github.com/uclibs/treatment_database
cd treatment_database

# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
yarn install

# Prepare the database
rails db:migrate
rails db:seed # Optional: Seed the database with initial data

# Compile JavaScript assets
yarn build

# Start the Rails server
rails server
```
For detailed migration steps, see [wiki](https://github.com/uclibs/treatment_database/wiki/Migration).

## Running the Tests

The Treatment Database has a test suite built with RSpec. Running it is simple, just call the following in the project directory:

```bash
bin/rails db:environment:set RAILS_ENV=test

bundle exec rspec
```
## Deployment Instructions

Use Capistrano for deploying to QA and Production environments; local deploy not supported.

### QA Deploy

1. Connect from VPN or on-campus network.
2. On your local terminal, type `cap qa deploy`.
3. When prompted, enter your apache username.
4. When prompted, enter your apache password.

Capistrano will deploy the `qa` branch by default from the GitHub repository for QA deploys. To switch branches for deploy to QA, alter [/config/deploy/qa.rb](https://github.com/uclibs/treatment_database/blob/qa/config/deploy/qa.rb#L5) (the branch must be pushed to remote).

### Production Deploy

1. Connect from VPN or on-campus network.
2. On your local terminal, type `cap production deploy`.
3. When prompted, enter your apache username.
4. When prompted, enter your apache password.

Capistrano will deploy the `main` branch from the GitHub repository by default for Production deploys.
