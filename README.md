# Treatment Database

This is a web application originally developed for the Preservation Lab at the University of Cincinnati. Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

# Run the application
1. `git clone github.com/uclibs/treatment_database`
1. `bundle install`
1. `rails db:migrate`
1. `rails db:seed`
1. `rails server`

Run tests: `bundle exec rspec

# Run the application using Docker
## Prerequisites
* [Docker](https://docs.docker.com/get-docker/) is properly installed on your computer.
* You have a copy of this repository ( `git clone https://github.com/uclibs/treatment_database.git` )

## Standalone
1. `cd \\to_the_treatment_database_directory`
1. `docker build -t treatment_image -f ./docker/Dockerfile .`
1. `docker run -d --name treatment_app -p 3000:3000 --env MODE=production -itP --rm treatment_image`

## Development
1. `cd \\to_the_treatment_database_directory`
1. `docker build -t treatment_image -f ./docker/Dockerfile .`
1. `docker run --name treatment_app -p 3000:3000 --env MODE=develop -itP --rm -v $(pwd):/treatment_database treatment_image`

## Docker Compose
1. `docker-compose build`
1. `docker-compose up`

After starting the application, visit this URL in a browser on the machine that is running the application: [http://localhost:3000](http://localhost:3000)

---

## Useful Docker Commands
> Note: A container is a Docker term that essentially means the application

| Command | Description |
| - | - |
| `docker ps` | Check which containers are running |
| `docker exec -it treatment_app rails c` | Runs the rails console with the currently running application |
| `docker exec -it treatment_app bash` | Opens a bash prompt in the currently running container |
| `docker stop treatment_app` | Stops the container |
| `docker rm treatment_app` | Removes the container |

## Run the Tests 

The treatment database has a test suite built with rspec, running it is simple, just call the following in the project directory:

Without Docker: `bundle exec rspec`

With Docker (application already running): `docker exec -it treatment_app bundle exec rspec`

## Generating PDFs
> Note: Running the application using Docker means that you don't need to install the wkhtmltopdf library

In several areas of the application we generate PDF reports. To accomplish this we use the gem PDFKit, which requires us to have the wkhtmltopdf library installed. You'll need to aquire wkhtmltopdf from their [download page](https://wkhtmltopdf.org/downloads.html). Alternatively, if you are using package manage I'd recommend installing it with that.

If you're running in a headless linux environment you'll likely the X virtual frame buffer. You can install this with yum and other popular package managers.

Finally, you'll need to add the following script to your bin `/usr/local/bin/wkhtmltopdf.sh`

`xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"`
