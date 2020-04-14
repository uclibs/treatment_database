# Treatment Database

This is a web application originally developed for the Preservation Lab at the University of Cincinnati.  Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

```bash
git clone github.com/uclibs/treatment_database
bundle install
rails db:migrate
rails server
```

#Dockerizing application

To dockerize the treatment database application use the following commands after setting up docker on your local machine or server.

```bash
cd \\to_the_treatment_database_directory
docker build -t treatment_database_image .
docker run -it --rm treatment_database_image bundle exec rake test
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


## Running the Tests
The treatment database has a test suite built with rspec, running it is simple, just call the following in the project directory:
```bash
docker exec -it treatment_database bundle exec rspec
```

## Generating PDFs

*This is automatically configured in the build; for troublesooting purposes only*

In several areas of the application we generate PDF reports.  To accomplish this we use the gem PDFKit, which requires us to have the wkhtmltopdf library installed.  You'll need to aquire wkhtmltopdf from their [download page](https://wkhtmltopdf.org/downloads.html).  Alternatively, if you are using package manage I'd recommend installing it with that.

If you're running in a headless linux environment you'll likely the X virtual frame buffer.  You can install this with yum and other popular package managers.

Finally, you'll need to add the following script to your bin `/usr/local/bin/wkhtmltopdf.sh`

```bash
xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"
```

