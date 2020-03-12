FROM ruby:2.5.1-alpine3.7


RUN apk --update add build-base sqlite-dev nodejs tzdata libxslt-dev libxml2-dev

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile* ./
RUN gem install bundler
RUN bundle install
COPY . ./
RUN rails db:migrate
EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]

CMD ["rails" ,"server" ,"-b" ,"0.0.0.0"]
