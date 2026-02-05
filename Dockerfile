FROM ruby:3.3.4-slim-bullseye

# Instala Git e dependências de banco de dados
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    npm && \
    npm install -g yarn

WORKDIR /app

# Copia os arquivos de dependências primeiro
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.17 && bundle install

# Copia TODO o restante do código para dentro de /app
COPY . .

# Garante que o diretório de trabalho seja /app para os comandos seguintes
RUN bundle exec rake assets:precompile

# Comando padrão para iniciar
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]