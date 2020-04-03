defmodule LinkettAdapterWeb.WorkOrdersControllerTest do
  use LinkettAdapterWeb.ConnCase
  use Placebo

  describe "GET /api/v1/terminals" do
    setup do
      bypass = Bypass.open()

      Application.put_env(
        :linkett_adapter,
        :endpoint,
        "http://localhost:#{bypass.port}/api/v1/"
      )

      %{bypass: bypass}
    end

    test "fetches data from the given linkett resource", %{
      conn: conn,
      bypass: bypass
    } do
      Bypass.expect(bypass, "GET", "/api/v1/terminals", fn conn ->
        Plug.Conn.resp(conn, 200, LinkettHelper.linkett_response(false) |> Jason.encode!())
      end)

      response = get(conn, "/api/v2/linkett/terminals") |> json_response(200)

      assert response == [
        %{"arbitrary_field" => 1},
        %{"arbitrary_field" => 2},
        %{"arbitrary_field" => 3}
      ]
    end

    test "returns 400 on bad_request response from linkett", %{
      conn: conn,
      bypass: bypass
    } do
      Bypass.expect(bypass, "GET", "/api/v1/terminal_error", fn conn ->
        error_body = %{code: "bad_request", msg: "msg"} |> Jason.encode!()
        Plug.Conn.resp(conn, 500, error_body)
      end)

      get(conn, "/api/v2/linkett/terminal_error") |> json_response(400)
    end

    test "returns 401 on unauthorized response from linkett", %{
      conn: conn,
      bypass: bypass
    } do
      Bypass.expect(bypass, "GET", "/api/v1/no_auth", fn conn ->
        error_body = %{code: "unauthorized", msg: "msg"} |> Jason.encode!()
        Plug.Conn.resp(conn, 401, error_body)
      end)

      get(conn, "/api/v2/linkett/no_auth") |> json_response(401)
    end
  end
end
