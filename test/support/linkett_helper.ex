defmodule LinkettHelper do
  def linkett_response(next) do
    data = %{
      "data" => %{
        "columns" => [
          "arbitrary_field"
        ],
        "rows" => [
          [
            1
          ],
          [
            2
          ],
          [
            3
          ]
        ]
      }
    }

    if next do
      Map.put(data, "next", 1234)
    else
      data
    end
  end

  def resp(conn, payload, code \\ 200) do
    conn |> Plug.Conn.put_resp_content_type("application/json") |> Plug.Conn.resp(code, payload |> Jason.encode!())
  end
end
