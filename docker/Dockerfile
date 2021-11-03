# Dockerfile for development mode
ARG RUBY_VERSION=2.7.4
# Note: Specifying the alpine version may result in issues if the image is discontinued
FROM ruby:${RUBY_VERSION}-alpine

# Install packages
RUN apk --update add build-base ncurses wkhtmltopdf xvfb xvfb-run nodejs sqlite-dev tzdata libxslt-dev libxml2-dev
RUN apk --update add openssh-server
RUN apk --update add mariadb-dev

# Setup application
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
COPY scripts/wkhtmltopdf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wkhtmltopdf.sh
RUN gem install bundler
RUN bundle install

# Setup entrypoint
COPY docker/entrypoint.sh docker/
RUN chmod +x docker/entrypoint.sh
ENTRYPOINT ["sh", "docker/entrypoint.sh"]
EXPOSE 3000

# Note: This is the command that is run by default, but it can be overwritten
CMD ["rails" ,"server" ,"-b" ,"0.0.0.0"]