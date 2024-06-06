# Treatment Database

This is a web application originally developed for the Preservation Lab at the University of Cincinnati. Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

## Prerequisites
- a current version of nvm
- Node >= 20.14.0
- Yarn >= 1.22.17
- Ruby 3.3.1
- Rails 6.1.7.7

### Notes:

#### Ruby Version Management
As of the new release of Ruby version 3.3.1, you need to use the following command to
install Ruby 3.3.1:
<br/>
With rvm:
```
rvm reinstall 3.3.1 --with-openssl-dir=`brew --prefix openssl@1.1` --with-opt-dir=`brew --prefix openssl@1.1
```
With rbenv:
```
CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1) --with-opt-dir=$(brew --prefix openssl@1.1)" rbenv install 3.3.1 && rbenv rehash
```

#### Node Version Management

This project uses nvm (Node Version Manager) to manage Node.js versions. The `.nvmrc` file is configured to use the
latest LTS version of Node, 20.14.0, to ensure compatibility with the latest features and security updates. 

When running locally, you will need to set the node version with `nvm use` as described below under "Installation".  
For deployment, the `.nvmrc` file will be used to set the node version and the deployment script will automatically
use the correct version.

## Installation

```bash
git clone github.com/uclibs/treatment_database
nvm install # Installs the node version listed in .nvmrc
nvm use # Directs to the correct node version listed in .nvmrc
bundle install
```

## Prepare the database.

```bash
rails db:migrate
rails db:seed
rails server
rails db:seed # (Optional, for example works)
```
### Important:
Running the db:seed is not sufficient to populate the database with the necessary data. You will need to import the data
for the controlled vocaublary and users.
See [wiki](https://github.com/uclibs/treatment_database/wiki/Migration) for migration steps.

## Running the Tests

The treatment database has a test suite built with rspec, running it is simple, just call the following in the project directory:

```bash
bundle exec rspec
```

## Deploy Instructions
Use Capistrano for deploying to QA and Production environments; local deploy not supported.
### QA deploy
1. Connect from VPN or on-campus network.
1. On local terminal, type `cap qa deploy`
1. When prompted, type apache username.
1. When prompted, type apache password.
   Capistrano will deploy the `qa` branch by default from the github repository for QA deploys. Switch branches for deploy to QA by altering [/config/deploy/qa.rb](https://github.com/uclibs/treatment_database/blob/qa/config/deploy/qa.rb#L5) (branch must be pushed to remote).
### Production deploy
1. Connect from VPN or on-campus network.
1. On local terminal, type `cap production deploy`
1. When prompted, type apache username.
1. When prompted, type apache password.
   Capistrano will deploy the `main` branch from the github repository by default for Production deploys.