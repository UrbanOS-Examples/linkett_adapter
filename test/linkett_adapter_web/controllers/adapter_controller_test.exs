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

    test "fetches data from the given linkett resource with all provided params", %{
      conn: conn,
      bypass: bypass
    } do
      key = "ASDAFA123"
      other_thing = "bob"
      a_param = "bob"
      Bypass.expect(bypass, "GET", "/api/v1/terminals", fn conn ->
        params = Plug.Conn.fetch_query_params(conn).params

        assert Map.get(params, "key") == key
        assert Map.get(params, "other_thing") == other_thing
        assert Map.get(params, "a_param") == a_param

        LinkettHelper.resp(conn, LinkettHelper.linkett_response(false), 200)
      end)

      response = get(conn, "/api/v1/linkett/terminals", %{"key" => key, "other_thing" => other_thing, "a_param" => a_param}) |> json_response(200)

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
        error_body = %{code: "bad_request", msg: "msg"}
        LinkettHelper.resp(conn, error_body, 500)
      end)

      get(conn, "/api/v1/linkett/terminal_error") |> json_response(400)
    end

    test "returns 401 on unauthorized response from linkett", %{
      conn: conn,
      bypass: bypass
    } do
      Bypass.expect(bypass, "GET", "/api/v1/no_auth", fn conn ->
        error_body = %{code: "unauthorized", msg: "msg"}
        LinkettHelper.resp(conn, error_body, 401)
      end)

      get(conn, "/api/v1/linkett/no_auth") |> json_response(401)
    end
  end
end
