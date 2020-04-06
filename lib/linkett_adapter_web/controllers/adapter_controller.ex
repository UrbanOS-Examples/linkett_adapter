defmodule LinkettAdapterWeb.AdapterController do
  use LinkettAdapterWeb, :controller

  require Logger

  def get_data(conn, %{"resource" => resource} = params) do
    key = Map.get(params, "key")
    try do
      data = LinkettAdapter.LinkettClient.fetch(resource, key)
      json(conn, data)
    rescue
      LinkettAdapter.Unauthorized -> unauthorized(conn)
      error in LinkettAdapter.BadRequest -> bad_request(conn, error)
      error ->
        Logger.error(Exception.format(:error, error, __STACKTRACE__))
        resp(conn, 500, "Unhandled exception: #{inspect(error)}")
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(401)
    |> json(%{message: "Unauthorized"})
  end

  defp bad_request(conn, error) do
    message = Map.get(error, "message")
    conn
    |> put_status(400)
    |> json(%{message: message})
  end
end
