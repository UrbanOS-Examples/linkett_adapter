defmodule LinkettAdapter.LinkettClientTest do
  use ExUnit.Case
  alias LinkettAdapter.LinkettClient

  describe "get /api/v1/activity_counters" do
    setup do
      bypass = Bypass.open()

      Application.put_env(
        :linkett_adapter,
        :endpoint,
        "http://localhost:#{bypass.port}/api/v1/"
      )

      %{bypass: bypass}
    end

    test "test pagination for activity_counter", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/api/v1/activity_counter", fn conn ->
        case Plug.Conn.fetch_query_params(conn).params do
          %{"next" => _next} ->
            Plug.Conn.resp(conn, 200, linkett_response(false) |> Jason.encode!())

          _ ->
            Plug.Conn.resp(conn, 200, linkett_response(true) |> Jason.encode!())
        end
      end)

      results = LinkettClient.fetch("activity_counter", "secret-key")

      assert Enum.count(results) == 6
    end
  end

  describe "row_col_to_map/1" do
    test "converts row col data to an elixir map" do
      data = linkett_response(false)

      response = LinkettClient.row_col_to_map(data)

      assert response == [
        %{"arbitrary_field" => 1},
        %{"arbitrary_field" => 2},
        %{"arbitrary_field" => 3}
      ]
    end
  end

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
end
