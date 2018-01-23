defmodule DeliriumTremex.Middleware.HandleErrors do
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  def call(%{errors: errors} = resolution, _config) when is_list(errors) do
    Resolution.put_result(resolution, {:error, format_errors(errors) |> IO.inspect()})
  end

  def call(resolution, _config) do
    resolution
  end

  defp format_errors(errors) do
    Enum.flat_map(errors, &format_error/1)
  end

  defp format_error(%Ecto.Changeset{} = changeset) do
    changeset
      |> Ecto.Changeset.traverse_errors(fn error -> error end)
      |> Enum.map(
        &DeliriumTremex.Formatters.Ecto.Changeset.format/1
      )
  end

  defp format_error(error) when is_map(error) do
    DeliriumTremex.Formatters.Map.format(error)
    |> List.wrap()
  end
end
