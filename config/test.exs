use Mix.Config

config :linkett_adapter, LinkettAdapterWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :linkett_adapter,
  linkett_credentials_key: "linkett_credentials",
  secrets_endpoint: "http://vault:8200"
