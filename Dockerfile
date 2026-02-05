# Instala dependências do Node.js
COPY package.json yarn.lock ./
RUN yarn install --check-files

# Precompile Rails assets (Vite)
RUN bundle exec rake assets:precompile