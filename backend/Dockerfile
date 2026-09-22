FROM ruby:3.4.10-slim AS base

WORKDIR /app

ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

FROM base AS build

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        libpq-dev \
        libyaml-dev \
        libffi-dev \
        pkg-config \
        imagemagick \
        shared-mime-info \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g corepack && \
    corepack enable && \
    corepack prepare yarn@1.22.22 --activate && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

COPY config/database.yml.example config/database.yml

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

FROM base AS production

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        libpq5 \
        shared-mime-info \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash app

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=app:app /app /app

RUN mkdir -p /app/tmp/pids /app/tmp/cache /app/tmp/sockets && \
    chown -R app:app /app/tmp

USER app

EXPOSE 5000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]