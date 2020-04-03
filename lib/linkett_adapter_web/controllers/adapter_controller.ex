defmodule LinkettAdapterWeb.AdapterController do
  use LinkettAdapterWeb, :controller

  require Logger

  def get_data(conn, %{"type" => type}) do
    try do
      data = LinkettAdapter.LinkettClient.fetch(type, 123)
      json(conn, data)
    rescue
      LinkettAdapter.Unauthorized -> unauthorized(conn)
      error in LinkettAdapter.BadRequest -> bad_request(conn, error)
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
