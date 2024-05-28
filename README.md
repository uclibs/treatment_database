# Treatment Database

This is a web application originally developed for the Preservation Lab at the University of Cincinnati. Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

```bash
git clone github.com/uclibs/treatment_database

bundle install

# Run the migration to prepare the database.

rails db:migrate

rails db:seed

rails server

rails db:seed (optional)

```

See [wiki](https://github.com/uclibs/treatment_database/wiki/Migration) for migration steps.

# Dockerizing application

To dockerize the treatment database application in **Development Mode** use the following commands after setting up docker on your local machine or server.

```bash
cd \\to_the_treatment_database_directory
docker build -t treatment_database_image .
docker run -it --rm treatment_database_image bundle exec rspec
docker run -d --name treatment_database -p 3000:3000 -itP -v $(pwd):/app treatment_database_image
```

Then to check the containers which are running:

```bash
docker ps
```

If running on local machine, access the app in the browser: [http://localhost:3000](http://localhost:3000)

Access the rails console:

```bash
docker exec -it treatment_database rails c
```

Access the shell:

```bash
docker exec -it treatment_database /bin/sh
```

To stop the container:

```bash
docker stop treatment_database
```

To delete the container:

```bash
docker rm treatment_database
```

To build the Docker image of the application in **Production Mode** and to run the app on NGINX server inside docker:

```bash
docker-compose build
```

Then:

```bash
docker-compose up
```

## Environment Setup
To set up your development environment:
1. Copy the `.env.example` file to `.env.development` and `.env.test` and fill in the necessary values.


## Running the Tests

The treatment database has a test suite built with rspec, running it is simple, just call the following in the project directory:

```bash
bin/rails db:migrate RAILS_ENV=test

bundle exec rspec

docker exec -it treatment_database bundle exec rspec
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
