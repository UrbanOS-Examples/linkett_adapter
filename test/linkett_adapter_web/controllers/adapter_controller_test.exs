defmodule LinkettAdapterWeb.WorkOrdersControllerTest do
  use LinkettAdapterWeb.ConnCase
  use Placebo

  @token "this-is-a-token"

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

    test "fetches work orders with provided range parameters when token can be retrieved", %{
      conn: conn,
      bypass: bypass
    } do
      Bypass.expect(bypass, "GET", "/api/v1/terminals", fn conn ->
        Plug.Conn.resp(conn, 200, "{}")
      end)

      conn = get(conn, "/api/v2/linkett/terminals")
      assert json_response(conn, 200) == "bob"
    end
  end

  # describe "GET /api/v1/work-resources" do
  #   setup do
  #     bypass = Bypass.open()

  #     Application.put_env(
  #       :linkett_adapter,
  #       :work_resources_endpoint,
  #       "http://localhost:#{bypass.port}/api/v1/work-resources"
  #     )

  #     %{bypass: bypass}
  #   end

  #   test "fetches work resources with provided range parameters when token can be retrieved", %{
  #     conn: conn,
  #     bypass: bypass
  #   } do
  #     allow(TokenGenerator.generate_token(), return: {:ok, @token})

  #     expected = []
  #     response_body = %{"features" => expected}
  #     range_start = "2019-12-10"
  #     range_end = "2019-12-11"

  #     Bypass.expect(bypass, fn conn ->
  #       assert conn.method == "GET"

  #       assert "Bearer #{@token}" in Plug.Conn.get_req_header(conn, "authorization")
  #       assert "application/json" in Plug.Conn.get_req_header(conn, "content-type")

  #       query_params = Plug.Conn.fetch_query_params(conn) |> Map.get(:query_params)

  #       assert %{
  #                "f" => "json",
  #                "outFields" => "*",
  #                "returnGeometry" => "false",
  #                "where" => "WR_MOD_DT BETWEEN DATE '#{range_start}' AND DATE '#{range_end}'"
  #              } == query_params

  #       Plug.Conn.resp(conn, :ok, Jason.encode!(response_body))
  #     end)

  #     conn =
  #       get(conn, "/api/v1/work-resources", %{
  #         "range_start" => range_start,
  #         "range_end" => range_end
  #       })

  #     assert json_response(conn, 200) == expected
  #   end

  #   test "returns only the list of feature attributes when the underlying work orders are retrieved successfully",
  #        %{
  #          conn: conn,
  #          bypass: bypass
  #        } do
  #     allow(TokenGenerator.generate_token(), return: {:ok, @token})

  #     response_body = %{
  #       "features" => [
  #         %{"attributes" => %{"WR_ID" => 19102, "WR_RTYP_TY" => "Equipment"}},
  #         %{"attributes" => %{"WR_ID" => 19103, "WR_RTYP_TY" => "Material"}}
  #       ]
  #     }

  #     Bypass.expect(bypass, fn conn ->
  #       Plug.Conn.resp(conn, :ok, Jason.encode!(response_body))
  #     end)

  #     conn =
  #       get(conn, "/api/v1/work-resources", %{
  #         "range_start" => "2019-12-10",
  #         "range_end" => "2019-12-11"
  #       })

  #     expected = response_body["features"] |> Enum.map(fn feature -> feature["attributes"] end)
  #     assert json_response(conn, 200) == expected
  #   end
  # end

  # describe "GET /api/v1/work-tasks" do
  #   setup do
  #     bypass = Bypass.open()

  #     Application.put_env(
  #       :linkett_adapter,
  #       :work_tasks_endpoint,
  #       "http://localhost:#{bypass.port}/api/v1/work-tasks"
  #     )

  #     %{bypass: bypass}
  #   end

  #   test "fetches work resources with provided range parameters when token can be retrieved", %{
  #     conn: conn,
  #     bypass: bypass
  #   } do
  #     allow(TokenGenerator.generate_token(), return: {:ok, @token})

  #     expected = []
  #     response_body = %{"features" => expected}
  #     range_start = "2019-12-10"
  #     range_end = "2019-12-11"

  #     Bypass.expect(bypass, fn conn ->
  #       assert conn.method == "GET"

  #       assert "Bearer #{@token}" in Plug.Conn.get_req_header(conn, "authorization")
  #       assert "application/json" in Plug.Conn.get_req_header(conn, "content-type")

  #       query_params = Plug.Conn.fetch_query_params(conn) |> Map.get(:query_params)

  #       assert %{
  #                "f" => "json",
  #                "outFields" => "*",
  #                "returnGeometry" => "false",
  #                "where" => "WT_MOD_DT BETWEEN DATE '#{range_start}' AND DATE '#{range_end}'"
  #              } == query_params

  #       Plug.Conn.resp(conn, :ok, Jason.encode!(response_body))
  #     end)

  #     conn =
  #       get(conn, "/api/v1/work-tasks", %{"range_start" => range_start, "range_end" => range_end})

  #     assert json_response(conn, 200) == expected
  #   end

  #   test "returns only the list of feature attributes when the underlying work orders are retrieved successfully",
  #        %{
  #          conn: conn,
  #          bypass: bypass
  #        } do
  #     allow(TokenGenerator.generate_token(), return: {:ok, @token})

  #     response_body = %{
  #       "features" => [
  #         %{"attributes" => %{"WT_ID" => 19102, "WR_TASK_TY" => "Stone Patching"}},
  #         %{"attributes" => %{"WT_ID" => 19103, "WR_RTYP_TY" => "Equipment Maintenance"}}
  #       ]
  #     }

  #     Bypass.expect(bypass, fn conn ->
  #       Plug.Conn.resp(conn, :ok, Jason.encode!(response_body))
  #     end)

  #     conn =
  #       get(conn, "/api/v1/work-tasks", %{
  #         "range_start" => "2019-12-10",
  #         "range_end" => "2019-12-11"
  #       })

  #     expected = response_body["features"] |> Enum.map(fn feature -> feature["attributes"] end)
  #     assert json_response(conn, 200) == expected
  #   end
  # end
end
