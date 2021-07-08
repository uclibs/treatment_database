ARG RUBY_VERSION=2
FROM ruby:${RUBY_VERSION}-alpine

RUN apk --update --no-cache add build-base ncurses wkhtmltopdf xvfb xvfb-run nodejs yarn sqlite-dev tzdata libxslt-dev libxml2-dev
RUN apk --update --no-cache add mariadb-dev

ARG RAILS_MASTER_KEY
# Set Rails to run in production
ENV RAILS_ENV='production'
ENV TREATMENT_DATABASE_ADAPTER='mysql2'

# Setting up a non-root User and Group inside the container
ENV RAILS_ROOT /opt/rails
ENV RAILS_USER rails
ENV RAILS_USER_ID 1001
ENV RAILS_GROUP rails
ENV RAILS_GROUP_ID 1001

# Create the non-root user
RUN addgroup -S $RAILS_USER -g $RAILS_GROUP_ID && adduser -S $RAILS_USER -G $RAILS_GROUP -h $RAILS_ROOT -u $RAILS_USER_ID

COPY scripts/wkhtmltopdf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wkhtmltopdf.sh

USER $RAILS_USER
WORKDIR $RAILS_ROOT

COPY --chown=rails:rails Gemfile* ./
RUN gem install bundler -v "$(cat Gemfile.lock | tail -1 | tr -d ' ')"  && bundle config set --local without 'development test' && bundle install --no-cache --jobs 20 --retry 5

COPY --chown=rails:rails . ./
# Precompile Rails assets.
RUN RAILS_MASTER_KEY=$RAILS_MASTER_KEY bundle exec rake assets:precompile
RUN mkdir -p $RAILS_ROOT/tmp/puma
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]