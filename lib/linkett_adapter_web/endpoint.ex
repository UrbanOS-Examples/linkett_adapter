defmodule LinkettAdapterWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :linkett_adapter

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_linkett_adapter_key",
    signing_salt: "TWlUMEC8"

  plug LinkettAdapterWeb.Router
end
