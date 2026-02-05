FROM ruby:3.3.4-slim-bullseye

# Instala dependências do sistema
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    npm && \
    npm install -g yarn

# Define o diretório de trabalho
WORKDIR /app

# Copia todo o código da aplicação para o diretório de trabalho
COPY . .

# Instala as gems do Bundler
RUN gem install bundler:2.5.17 && bundle install

# Instala as dependências Node.js
RUN yarn install --frozen-lockfile

# Precompila os assets
RUN bundle exec rake assets:precompile

# Comando padrão para iniciar
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]