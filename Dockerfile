FROM ruby:2.5.1

RUN apt-get update && apt-get install -y \
    build-essential \
      sqlite3

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile* ./
RUN gem install bundler
RUN bundle install
RUN rails db:migrate
COPY . ./

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["rails" ,"server" ,"-b" ,"0.0.0.0"]
