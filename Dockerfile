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