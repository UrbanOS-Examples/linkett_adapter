defmodule LinkettAdapter.BadRequest do
  defexception message: "bad request"
end

defmodule LinkettAdapter.Unauthorized do
  defexception message: "unauthorized"
end
