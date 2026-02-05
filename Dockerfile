# Use uma imagem base do Ruby com as ferramentas necessárias
FROM ruby:3.3.4-slim-bullseye

# Instala dependências do sistema
RUN apt-get update -qq &#x26;&#x26; apt-get install -y nodejs npm yarn postgresql-client build-essential git libvips

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o Gemfile e Gemfile.lock para instalar as dependências do Ruby
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Instala dependências do Node.js
COPY package.json yarn.lock ./
RUN yarn install --check-files

# Copia o restante do código da aplicação
COPY . .

# Pré-compila os assets do Rails (Vite)
RUN bundle exec rake assets:precompile

# Expõe a porta que a aplicação Rails usará
EXPOSE 3000

# Comando para iniciar a aplicação (pode ser ajustado conforme seu Procfile.dev ou bin/dev)
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]