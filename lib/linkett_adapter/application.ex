defmodule LinkettAdapter.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      LinkettAdapterWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LinkettAdapter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    LinkettAdapterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
