FROM ruby:2.7.3-alpine
RUN apk --update --no-cache add build-base ncurses wkhtmltopdf xvfb xvfb-run nodejs yarn sqlite-dev tzdata libxslt-dev libxml2-dev
RUN apk --update --no-cache add openssh-server mariadb-dev

ARG RAILS_MASTER_KEY
# Set Rails to run in production
ENV RAILS_ENV='production'
ENV TREATMENT_DATABASE_ADAPTER='mysql2'

ENV RAILS_ROOT /var/www/treatment_app
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT
COPY scripts/wkhtmltopdf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wkhtmltopdf.sh
COPY Gemfile* ./
RUN gem install bundler -v "$(cat Gemfile.lock | tail -1 | tr -d ' ')" && bundle config set --local without 'development test' && bundle install --no-cache --jobs 20 --retry 5

COPY . ./
# Precompile Rails assets.
RUN RAILS_MASTER_KEY=$RAILS_MASTER_KEY bundle exec rake assets:precompile
RUN mkdir -p $RAILS_ROOT/tmp/puma
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]