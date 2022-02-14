FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk add --update --no-cache py3-arrow


RUN mix local.hex --force && \
		mix local.rebar --force && \
		mix hex.config http_concurrency 1 && \
		mix hex.config http_timeout 120

COPY mix.exs mix.exs ./
COPY config config

RUN mix do deps.get, deps.compile

COPY priv priv
COPY lib lib

COPY docker_dev_start.sh docker_dev_start.sh

EXPOSE 4000
