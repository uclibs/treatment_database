#Use base image of ruby 2.7.5
ARG RUBY_VERSION=2.7.5
FROM ruby:${RUBY_VERSION}

#Install all necessary dependencies 
RUN apt-get update && apt-get install -y npm && npm install -g yarn
RUN apt-get install -y build-essential && apt-get install -y libncurses5-dev && apt-get install -y xvfb 
RUN apt-get install -y sqlite3 libxml2-dev libxml2
RUN apt-get install -y mariadb-server
RUN apt-get install -y sudo

ARG RAILS_MASTER_KEY
# Set Rails to run in production
ENV RAILS_ENV='production'
ENV TREATMENT_DATABASE_ADAPTER='mysql2'

# Setting up a non-root User and Group inside the container
ENV RAILS_ROOT /opt/rails
ENV RAILS_USER rail
ENV RAILS_USER_ID 1001
ENV RAILS_GROUP rails
ENV RAILS_GROUP_ID 1002

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Create the non-root user
#RUN apt-get install adduser

#RUN addgroup $RAILS_GROUP -g $RAILS_GROUP_ID && adduser -u $RAILS_USER_ID -G $RAILS_GROUP $RAILS_USER
RUN groupadd -g $RAILS_GROUP_ID $RAILS_GROUP
RUN useradd -u $RAILS_USER_ID  $RAILS_USER
RUN usermod -a -G $RAILS_GROUP $RAILS_USER
RUN chown $RAILS_USER  $RAILS_ROOT
#RUN chown $RAILS_GROUP $RAILS_ROOT

COPY scripts/wkhtmltopdf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wkhtmltopdf.sh

#Create user and exit if the user exist .Then add to sudo users
RUN adduser $RAILS_USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $RAILS_USER

COPY --chown=rail:rail Gemfile* /opt/rails/

COPY --chown=rail:rail . /opt/rails/

RUN export PATH="/opt/rails/.gem/ruby/2.7.0/bin:$PATH"

#RUN gem install bundler 2.2.27
RUN bundle config set --local without 'development test' && bundle install --no-cache --jobs 20 --retry 5

# Precompile Rails assets.
RUN RAILS_MASTER_KEY=$RAILS_MASTER_KEY bundle exec rake assets:precompile
RUN mkdir -p $RAILS_ROOT/tmp/puma
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

