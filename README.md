# Treatment Database

This is a web application originally developed for the Preservation Lab at the University of Cincinnati. Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

## Prerequisites

- Node >= 20.14.0
- Yarn >= 1.22.17
- Ruby 3.3.6
- Rails ~> 6.1.7.10

### Notes:

#### Ruby Version Management
With rbenv and homebrew:
```
brew upgrade ruby-build # Latest version of ruby-build is needed to install Ruby 3.3.6
rbenv install 3.3.6
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
bundle install # Installs the Ruby gems
yarn install # Installs the node modules
yarn build # Builds the front-end assets
```

## Preparing the Database
Before you can run the application, you need to set up the database. Follow these steps to prepare the database:

### Migrate the Database
   Run the database migrations to set up the necessary tables:
```
rails db:create
rails db:migrate
```
### Seed the Database
#### For Development and Test Environments:

In development and test environments, running the seeds will create some default user accounts and sample conservation records. These are intended for testing and local development purposes.
```
rails db:seed
```
#### For Production Environments:

In production, the default seed data is not automatically created to avoid adding test accounts and sample data. If you need to seed specific production data, you can manually add it to the db/seeds/production.rb file or run specific tasks designed for production.
```
# Example (only if necessary and defined in your seeds):
RAILS_ENV=production rails db:seed
Note: Be cautious when seeding in production to avoid inserting unintended data.
```

### Start the Server
   Once the database is prepared, you can start the server:

```
rails server
```

## Local Deployment and Development
In production, the app uses SSO with Shibboleth for authentication. For local development, 
a simple username and password is used to streamline the setup.

Key Differences:
- Production: SSO with Shibboleth.
- Local: Username and password.
- Most tests use the local username/password setup.
- SSO-specific tests simulate the production environment using mock data.

## Running the Tests

The treatment database has a test suite built with rspec, running it is simple, just call the following in the project directory:

### Automated Testing
```bash
# If you haven't already done so, run:
bundle instal
yarn instal
yarn build
# and then run the tests with:
bundle exec rspec
```

### Manual Testing
When you ran `rails db:seed`, you created three user accounts:
- an admin account with the username `chuck@uc.edu` and password `notapass`
- a standard user account with the username `jkrowling@uc.edu` and password `notapass`
- a read-only user account with the email `johngreen@uc.edu` and password `notapass`

You can use these accounts to test the application. The admin account has full access to the application, the standard
user account has access to most features, and the read-only user account can only view the data.

## Deploy Instructions
Use Capistrano for deploying to QA and Production environments; local deploy not supported.  QA and Production
need to be already configured for SSO with Shibboleth.

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
