# DelirimTremex - standardised GraphQL error handling through Absinthe
# Copyright (C) 2018 FloatingPoint.io
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

  defp format_error(%Ecto.Changeset{} = changeset) do
    changeset
      |> Ecto.Changeset.traverse_errors(fn error -> error end)
      |> Enum.map(
        &DeliriumTremex.Formatters.Ecto.Changeset.format/1
      )
  end

  defp format_error(error) when is_map(error) do
    DeliriumTremex.Formatters.Map.format(error)
  end

  defp format_error(error) when is_atom(error) do
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

  defp format_error(_) do
    DeliriumTremex.Formatters.Map.format(unknown_error)
  end

  defp unknown_error do
    %{
      key: :unknown_error,
      message: "Something went wrong",
      messages: ["Something went wrong"]
    }
  end
end
