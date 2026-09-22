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
        libpq-dev \
        libyaml-dev \
        libffi-dev \
        pkg-config \
        imagemagick \
        shared-mime-info \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
COPY config/database.yml.example /app/config/database.yml

RUN bundle install

COPY . .

COPY config/database.yml.example config/database.yml

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

FROM base AS production

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        libpq5 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash app

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=app:app /app /app

USER app

EXPOSE 5000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]