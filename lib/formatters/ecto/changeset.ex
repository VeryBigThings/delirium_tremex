defmodule DeliriumTremex.Formatters.Ecto.Changeset do
  @spec format(error :: tuple()) :: Keyword.t()
  def format({key, [%{} | _] = errors} = _error) when is_list(errors) do
    errors = remove_empty_maps(errors)

    Enum.reduce(errors, [], fn err, acc ->
      merge_suberror_kw_lists(acc, format({key, err}))
    end)
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
      suberrors: Enum.map(errors, fn err -> format(err) |> Enum.into(%{}) end)
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

  defp merge_suberror_kw_lists(kw_list1, kw_list2) do
    Keyword.merge(kw_list1, kw_list2, fn key, v1, v2 ->
      case key do
        :suberrors -> Enum.concat(v1, v2)
        _ -> v1
      end
    end)
  end

  defp remove_empty_maps(list_of_maps) do
    Enum.filter(list_of_maps, fn x -> map_size(x) > 0 end)
  end
end
