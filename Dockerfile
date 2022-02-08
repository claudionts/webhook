FROM bitwalker/alpine-elixir-phoenix:1.13

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets

CMD mix deps.get && cd assets && npm install && cd .. && mix phx.server
