use Mix.Config

config :linkett_adapter, LinkettAdapterWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :linkett_adapter, LinkettAdapterWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"lib/linkett_adapter_web/{live,views}/.*(ex)$",
      ~r"lib/linkett_adapter_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :linkett_adapter,
  secret_retriever: LinkettAdapter.SecretRetrieverLocal

config :linkett_adapter,
  linkett_credentials_key: "linkett_credentials",
  generate_token_endpoint: "https://arc.columbus.gov/arcgis/tokens/generateToken",
  work_orders_endpoint:
    "https://arc.columbus.gov/arcgis/rest/services/Test/LucityWorkOrder/MapServer/1/query",
  work_resources_endpoint:
    "https://arc.columbus.gov/arcgis/rest/services/Test/LucityWorkOrder/MapServer/2/query",
  work_tasks_endpoint:
    "https://arc.columbus.gov/arcgis/rest/services/Test/LucityWorkOrder/MapServer/3/query"
