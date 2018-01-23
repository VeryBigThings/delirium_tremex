defmodule DeliriumTremex.Formatters.Map do
  import DeliriumTremex, only: [wrap_list: 1]

  def format(error) do
    [
      message: (error[:messages] || "Error") |> wrap_list() |> hd(),
      key: error[:key],
      messages: error[:messages],
      full_messages: error[:full_messages] || error[:messages],
      index: error[:index],
      suberrors: error[:suberrors]
    ]
  end
end
