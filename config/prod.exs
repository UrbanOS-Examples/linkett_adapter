use Mix.Config

config :linkett_adapter, LinkettAdapterWeb.Endpoint,
  http: [:inet6, port: 4000],
  server: true,
  root: ".",
  version: Application.spec(:linkett_adapter, :vsn)

config :logger, level: :info
