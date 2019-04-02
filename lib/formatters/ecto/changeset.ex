defmodule DeliriumTremex.Formatters.Ecto.Changeset do
  def format({key, [%{} | _] = errors} = _error) when is_list(errors) do
    errors = Enum.filter(errors, fn x -> not (x == %{}) end)
    human_key = humanize(key)

    [
      message: "#{human_key} errors",
      key: key,
      messages: nil,
      full_messages: nil,
      index: nil,
      suberrors:
        Enum.map(errors, fn err -> format({key, err}) end) |> Enum.map(&convert_list_to_map/1)
    ]
  end

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
      suberrors: Enum.map(errors, &format/1) |> Enum.map(&convert_list_to_map/1)
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

  defp convert_list_to_map(keyword_list) do
    keyword_list
    |> Enum.into(%{})
  end
end
