FROM ruby:2.6.6-alpine3.11
RUN apk --update add build-base ncurses wkhtmltopdf xvfb xvfb-run nodejs postgresql postgresql-contrib sqlite-dev tzdata libxslt-dev libxml2-dev
RUN apk --update add openssh-server
RUN apk --update add mariadb-dev

# Set Rails to run in production
ENV RAILS_ENV='production' 
ENV RACK_ENV='production'

ENV RAILS_ROOT /var/www/treatment_app
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
COPY scripts/wkhtmltopdf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wkhtmltopdf.sh
COPY Gemfile* ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test

COPY . ./
# Precompile Rails assets.
RUN bundle exec rake assets:precompile

EXPOSE 3000

# ENTRYPOINT ["bundle", "exec"]
# CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]