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
  endpoint: "https://portal3.linkett.com/api/v1/"
