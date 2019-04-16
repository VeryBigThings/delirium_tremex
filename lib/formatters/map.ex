defmodule DeliriumTremex.Formatters.Map do
  @spec format(error :: map()) :: [map()]
  def format(%{key: _, messages: _} = error) do
    %{
      message: (error[:message] || error[:messages] || "Error") |> List.wrap() |> hd(),
      key: error[:key],
      messages: error[:messages] |> List.wrap(),
      full_messages: error[:full_messages] || error[:messages],
      index: error[:index],
      suberrors: error[:suberrors]
    }
    |> List.wrap()
  end
end
