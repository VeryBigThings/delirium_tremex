defmodule DeliriumTremex.Middleware.HandleErrors do
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  @error_builder Confex.get_env(DeliriumTremex.Mixfile.project()[:app], :error_builder)

  def call(%{errors: errors} = resolution, _config) when is_list(errors) do
    Resolution.put_result(resolution, {:error, format_errors(errors)})
  end

  def call(resolution, _config) do
    resolution
  end

  defp format_errors(errors) do
    Enum.flat_map(errors, &format_error/1)
  end

  defp format_error(error) do
    cond do
      is_atom(error) -> format_atom_error(error)
      is_map?(error) -> format_map_error(error)
      is_changeset?(error) -> format_changeset_error(error)
      true -> format_unknown_error(error)
    end
  end

  defp format_changeset_error(changeset) do
    changeset
      |> Ecto.Changeset.traverse_errors(fn error -> error end)
      |> Enum.map(
        &DeliriumTremex.Formatters.Ecto.Changeset.format/1
      )
  end

  defp format_map_error(error) do
    DeliriumTremex.Formatters.Map.format(error)
  end

  defp format_atom_error(error) do
    with \
      false <- is_nil(@error_builder),
      true <- Keyword.has_key?(@error_builder.__info__(:functions), error),
      %{message: _, messages: _} = error_message <- apply(@error_builder, error, [])
    do
      Map.put(error_message, :key, error)
    else
      _ -> unknown_error()
    end
    |> DeliriumTremex.Formatters.Map.format()
  end

  defp format_unknown_error(_) do
    DeliriumTremex.Formatters.Map.format(unknown_error())
  end

  defp unknown_error do
    %{
      key: :unknown_error,
      message: "Something went wrong",
      messages: ["Something went wrong"]
    }
  end

  defp is_changeset?(error) do
    with \
      {:module, Ecto.Changeset} <- Code.ensure_compiled(Ecto.Changeset),
      Ecto.Changeset <- Map.get(error, :__struct__)
    do
      true
    else
      _ -> false
    end
  end

  defp is_map?(error) do
    is_map(error) && !Map.has_key?(error, :__struct__)
  end
end
