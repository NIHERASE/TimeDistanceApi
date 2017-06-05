FROM elixir:1.4.4
ADD . /app
WORKDIR /app
RUN mix local.hex --force
RUN mix do deps.get
