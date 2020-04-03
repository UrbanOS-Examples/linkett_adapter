defmodule LinkettAdapter.LinkettClientTest do
  use ExUnit.Case
  alias LinkettAdapter.LinkettClient

  setup_all do
    bypass = Bypass.open()

    Application.put_env(
      :linkett_adapter,
      :endpoint,
      "http://localhost:#{bypass.port}/api/v1/"
    )

    %{bypass: bypass}
  end

  describe "get /api/v1/activity_counters" do
    test "test pagination for activity_counter", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/api/v1/activity_counter", fn conn ->
        case Plug.Conn.fetch_query_params(conn).params do
          %{"next" => _next} ->
            Plug.Conn.resp(conn, 200, LinkettHelper.linkett_response(false) |> Jason.encode!())

          _ ->
            Plug.Conn.resp(conn, 200, LinkettHelper.linkett_response(true) |> Jason.encode!())
        end
      end)

      results = LinkettClient.fetch("activity_counter", "secret-key")

      assert Enum.count(results) == 6
    end
  end

  describe "row_col_to_map/1" do
    test "converts row col data to an elixir map" do
      data = LinkettHelper.linkett_response(false)

      response = LinkettClient.row_col_to_map(data)

      assert response == [
               %{"arbitrary_field" => 1},
               %{"arbitrary_field" => 2},
               %{"arbitrary_field" => 3}
             ]
    end

    test "converts row col data with multiple columns to an elixir map" do
      data = %{
        "data" => %{
          "columns" => [
            "arbitrary_field",
            "another_field"
          ],
          "rows" => [
            [
              1,
              "b"
            ]
          ]
        }
      }

      response = LinkettClient.row_col_to_map(data)

      assert response == [
               %{"arbitrary_field" => 1, "another_field" => "b"}
             ]
    end
  end

  describe "errors from linkett flow through the adapter" do
    test "the adapter handles 500 internal server error", %{bypass: bypass} do
      error_body = %{code: "bad_request", msg: "msg"}

      Bypass.expect(bypass, "GET", "/api/v1/error_counter", fn conn ->
        Plug.Conn.resp(conn, 500, error_body |> Jason.encode!())
      end)

      assert_raise LinkettAdapter.BadRequest, "msg", fn ->
        LinkettClient.fetch("error_counter", "secret-key")
      end
    end

    test "the adapter handles 401 unauthorized", %{bypass: bypass} do
      error_body = %{code: "unauthorized", msg: "msg"} |> Jason.encode!()

      Bypass.expect(bypass, "GET", "/api/v1/no_auth", fn conn ->
        Plug.Conn.resp(conn, 401, error_body)
      end)

      assert_raise LinkettAdapter.Unauthorized, fn ->
        LinkettClient.fetch("no_auth", "secret-key")
      end
    end
  end
end
