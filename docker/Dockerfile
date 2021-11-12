# Dockerfile for development mode
ARG RUBY_VERSION=2.7.4
ARG MODE
# Note: Specifying the alpine version may result in issues if the image is discontinued
FROM ruby:${RUBY_VERSION}
# FROM circleci/ruby:${RUBY_VERSION}-node-browsers

# Install packages
RUN apt-get update -qq && apt-get install -y git bash bash-completion wkhtmltopdf xvfb nodejs tzdata libxslt-dev libxml2-dev openssh-server chromium python3 python3-dev
# RUN pip install --upgrade pip
# RUN pip3 install -U selenium

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