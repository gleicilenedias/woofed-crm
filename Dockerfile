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

# Copia Gemfile e Gemfile.lock para instalar as gems
COPY Gemfile Gemfile.lock ./

# Instala as gems do Bundler
RUN gem install bundler:2.5.17 && bundle install

# Copia package.json e yarn.lock para instalar as dependências Node.js
COPY package.json yarn.lock ./

# Instala as dependências Node.js
RUN yarn install --frozen-lockfile

# Copia o restante do código da aplicação
COPY . .

# Garante que o diretório de trabalho seja /app para os comandos seguintes
RUN bundle exec rake assets:precompile

# Comando padrão para iniciar
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]