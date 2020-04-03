use Mix.Config

required_envars = [
  "PORT",
  "LINKETT_CREDENTIALS_KEY",
  "LINKETT_GENERATE_TOKENS_ENDPOINT",
  "LINKETT_WORK_ORDERS_ENDPOINT",
  "LINKETT_WORK_RESOURCES_ENDPOINT",
  "LINKETT_WORK_TASKS_ENDPOINT",
  "SECRETS_ENDPOINT"
]

Enum.each(required_envars, fn var ->
  if is_nil(System.get_env(var)) do
    raise ArgumentError, message: "Required environment variable #{var} is undefined"
  end
end)

config :linkett_adapter, LinkettAdapterWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")]

config :linkett_adapter,
  linkett_credentials_key: System.get_env("LINKETT_CREDENTIALS_KEY"),
  generate_token_endpoint: System.get_env("LINKETT_GENERATE_TOKENS_ENDPOINT"),
  work_orders_endpoint: System.get_env("LINKETT_WORK_ORDERS_ENDPOINT"),
  work_resources_endpoint: System.get_env("LINKETT_WORK_RESOURCES_ENDPOINT"),
  work_tasks_endpoint: System.get_env("LINKETT_WORK_TASKS_ENDPOINT"),
  secrets_endpoint: System.get_env("SECRETS_ENDPOINT")
