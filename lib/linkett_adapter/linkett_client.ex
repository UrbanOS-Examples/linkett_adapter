defmodule LinkettAdapter.LinkettClient do
  use Tesla
  require Logger

  plug Tesla.Middleware.JSON

  def fetch(type, key) do
    Stream.resource(
      fn -> get_data(type, [key: key]) end,
      fn body ->
        next_data(body, type, key)
      end,
      fn _ ->
        Logger.debug("Finished pagination for #{type}")
      end
    )
    |> Stream.flat_map(&row_col_to_map/1)
    |> Enum.to_list()
  end

  def get_data(type, params) do
    endpoint = Application.get_env(:linkett_adapter, :endpoint)

    with %Tesla.Env{status: 200} = response <- "#{endpoint}#{type}" |> get!(query: params) do
      response
        |> Map.get(:body)
    else
      %Tesla.Env{status: 500, body: body} -> raise LinkettAdapter.BadRequest, body
      %Tesla.Env{status: 401} -> raise LinkettAdapter.Unauthorized
      %Tesla.Env{status: 404} -> raise "Resource not found"
    end
  end

  def next_data(:end, _type, _key) do
    {:halt, :end}
  end

  def next_data(body, type, key) do
    case body do
      %{"next" => paginator} when not is_nil(paginator) ->
        {[body], get_data(type, [key: key, next: paginator])}
      _ ->
        {[body], :end}
    end
  end

  def row_col_to_map(%{"data" => %{"columns" => columns, "rows" => rows}}) do
    rows
    |> Enum.map(&Enum.zip(columns, &1))
    |> Enum.map(&Map.new/1)
  end
end
