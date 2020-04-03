use Mix.Config

config :linkett_adapter, LinkettAdapterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D6cZMvJJruawUj/bQ5LoEERSqb8ntBbbFFFpaZoBRCTTqt2Wo/dL//pPfZZpyHXc",
  render_errors: [view: LinkettAdapterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LinkettAdapter.PubSub, adapter: Phoenix.PubSub.PG2]

config :linkett_adapter,
  endpoint: "https://portal3.linkett.com/api/v1/"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
