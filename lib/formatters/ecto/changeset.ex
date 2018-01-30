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

defmodule DeliriumTremex.Formatters.Ecto.Changeset do
  def format({key, errors} = _error) when is_list(errors) do
    full_messages =
      build_full_messages(key, errors)
      |> List.wrap()
    message = full_messages |> hd()

    [
      message: message || "Error",
      key: key,
      messages: build_messages(errors) |> List.wrap(),
      full_messages: full_messages,
      index: nil,
      suberrors: nil
    ]
  end

  def format({key, errors} = _error) when is_map(errors) do
    human_key = humanize(key)
    [
      message: "#{human_key} errors",
      key: key,
      messages: nil,
      full_messages: nil,
      index: nil,
      suberrors: Enum.map(errors, &format/1)
    ]
  end

  def format({key, errors} = _error) when is_tuple(errors) do
    format({key, List.wrap(errors)})
  end

  defp humanize(string), do: string |> to_string() |> String.capitalize()

  defp build_messages(errors) do
    Enum.map(
      errors,
      fn {value, context} -> translate_error({value, context}) end
    )
  end

  defp build_full_messages(key, errors) do
    human_key = humanize(key)
    Enum.map(
      errors,
      fn {value, context} ->
        "#{human_key} #{translate_error({value, context})}"
      end
    )
  end

  defp translate_error({msg, opts}) do
    Gettext.dgettext(DeliriumTremex.Gettext, "errors", msg, opts)
  end
end
