defmodule LinkettAdapterWeb.Router do
  use LinkettAdapterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  end

  scope "/api/v1", LinkettAdapterWeb do
    get "/healthcheck", HealthCheckController, :index
  end

  scope "/api/v1/linkett", LinkettAdapterWeb do
    pipe_through :api

    get "/:resource", AdapterController, :get_data
  end
end
