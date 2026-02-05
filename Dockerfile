FROM ruby:3.3.0-slim-bullseye

RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client imagemagick libvips && \
    npm install -g yarn

WORKDIR /app

COPY . .

RUN bundle install --jobs=$(nproc) --retry=3
RUN yarn install --no-immutable
RUN bundle exec rake assets:precompile

# Entrypoint and CMD remain the same
ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]