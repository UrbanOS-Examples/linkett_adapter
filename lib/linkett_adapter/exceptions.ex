defmodule LinkettAdapter.BadRequest do
  defexception message: "bad request"

  def exception(message) do
    %LinkettAdapter.BadRequest{message: Map.get(message, "msg")}
  end
end

defmodule LinkettAdapter.Unauthorized do
  defexception message: "unauthorized"
end
