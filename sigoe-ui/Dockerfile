FROM oven/bun:1 AS build

WORKDIR /app

COPY package.json bun.lock ./

RUN bun install --frozen-lockfile

COPY . .

ARG BASE_URL
ENV BASE_URL=$BASE_URL

RUN bun run build

FROM oven/bun:1-slim

WORKDIR /app

RUN bun add serve

COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD ["sh", "-c", "bunx serve -s dist -l ${PORT:-3000}"]