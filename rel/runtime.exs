use Mix.Config

config :doim_adapter, LinkettAdapterWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")]
