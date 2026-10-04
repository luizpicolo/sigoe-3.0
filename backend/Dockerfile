FROM ruby:4.0.7-slim AS base

WORKDIR /app

ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"


# ==================================================
# BUILD
# ==================================================

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


# Ruby dependencies
COPY Gemfile Gemfile.lock ./

RUN --mount=type=cache,target=/usr/local/bundle/cache \
    bundle install


# Application
COPY . .

COPY config/database.yml.example config/database.yml


# ==================================================
# PRODUCTION
# ==================================================

FROM base AS production

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        libpq5 \
        shared-mime-info \
    && rm -rf /var/lib/apt/lists/*


RUN useradd \
    --create-home \
    --shell /bin/bash \
    app


COPY --from=build /usr/local/bundle /usr/local/bundle

COPY --from=build \
    --chown=app:app \
    /app \
    /app


RUN mkdir -p \
        /app/tmp/pids \
        /app/tmp/cache \
        /app/tmp/sockets && \
    chown -R app:app /app/tmp


USER app

EXPOSE 5000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
