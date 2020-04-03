use Mix.Config

config :linkett_adapter, LinkettAdapterWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
