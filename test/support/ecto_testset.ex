defmodule Ecto.Testset do
  defstruct action: nil,
    changes: %{},
    errors: [],
    data: nil,
    valid?: false
end