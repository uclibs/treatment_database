# Base image
FROM nginx
# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils
# where Nginx should look for files
ENV RAILS_ROOT /var/www/treatment_app
# Set our working directory inside the image
WORKDIR $RAILS_ROOT
# create log directory
RUN mkdir log
# copy over static assets
COPY public public/
# Copy Nginx config template
COPY docker/web/nginx.conf /tmp/docker.nginx
# substitute variable references in the Nginx config template for real values from the environment 
# put the final config in its place
RUN envsubst '$RAILS_ROOT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
