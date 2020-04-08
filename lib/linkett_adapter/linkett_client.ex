defmodule LinkettAdapter.LinkettClient do
  use Tesla
  require Logger

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Retry,
    delay: 1000,
    max_retries: 5,
    max_delay: 5_000,
    should_retry: fn
      {:ok, %{status: 503}} -> true
      {:ok, _} -> false
      {:error, _} -> false
    end

  def fetch(resource, params) do
    Stream.resource(
      fn -> get_data(resource, params) end,
      fn body ->
        next_data(body, resource, params)
      end,
      fn _ ->
        Logger.debug("Finished pagination for #{resource}")
      end
    )
    |> Stream.flat_map(&row_col_to_map/1)
    |> Enum.to_list()
  end

  def get_data(resource, params) do
    endpoint = Application.get_env(:linkett_adapter, :endpoint)

    with %Tesla.Env{status: 200} = response <- "#{endpoint}#{resource}" |> get!(query: params) do
      response
        |> Map.get(:body)
    else
      %Tesla.Env{status: 500, body: body} -> raise LinkettAdapter.BadRequest, body
      %Tesla.Env{status: 401} -> raise LinkettAdapter.Unauthorized
      %Tesla.Env{status: 404} -> raise "Resource not found"
    end
  end

  def next_data(:end, _resource, _key) do
    {:halt, :end}
  end

  def next_data(body, resource, params) do
    case body do
      %{"next" => paginator} when not is_nil(paginator) ->
        {[body], get_data(resource, Map.put(params, :next, paginator))}
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
