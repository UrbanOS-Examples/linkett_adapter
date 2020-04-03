defmodule LinkettAdapter.LinkettClient do
  use Tesla

  # plug Tesla.Middleware.Query, [key: "some-token"]
  plug Tesla.Middleware.JSON

  def fetch(type, key) do
    endpoint = Application.get_env(:linkett_adapter, :endpoint)
    Stream.resource(fn -> get!("#{endpoint}#{type}", query: [key: key]) end,
      fn res -> {:halt, res} end,
      fn another_res -> another_res end
    )
  end
end
