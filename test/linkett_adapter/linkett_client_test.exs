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
        Plug.Conn.resp(conn, 200, %{next: 12345} |> Jason.encode!())
      end)

      LinkettClient.fetch("activity_counter", "secret-key") |> IO.inspect(label: "what am i")
    end

  end

end
