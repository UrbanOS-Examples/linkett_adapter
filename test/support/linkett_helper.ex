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
end
