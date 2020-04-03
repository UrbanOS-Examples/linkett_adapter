defmodule LinkettAdapter.BadRequest do
  defexception message: "bad request"

  def exception(message_json) do
    msg = message_json |> Jason.decode!() |> Map.get("msg")
    %LinkettAdapter.BadRequest{message: msg}
  end
end

defmodule LinkettAdapter.Unauthorized do
  defexception message: "unauthorized"
end
