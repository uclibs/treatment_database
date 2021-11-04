# Dockerfile for development mode
ARG RUBY_VERSION=2.7.4
ARG MODE
# Note: Specifying the alpine version may result in issues if the image is discontinued
FROM ruby:${RUBY_VERSION}-alpine
# FROM circleci/ruby:${RUBY_VERSION}-node-browsers

# Install packages
RUN apk --update add git bash bash-completion build-base ncurses wkhtmltopdf xvfb xvfb-run nodejs sqlite-dev tzdata libxslt-dev libxml2-dev openssh-server mariadb-dev

# Setup application
WORKDIR /treatment_database
COPY Gemfile* .
COPY scripts/wkhtmltopdf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wkhtmltopdf.sh
RUN gem install bundler
RUN bundle install

# Setup entrypoint
COPY docker/entrypoint.sh docker/
RUN chmod +x docker/entrypoint.sh
ENTRYPOINT ["bash", "docker/entrypoint.sh"]
EXPOSE 3000

# Note: This is the command that is run by default, but it can be overwritten
CMD ["rails" ,"server" ,"-b" ,"0.0.0.0"]