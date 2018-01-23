defmodule DeliriumTremex do
  @moduledoc """
  Documentation for DeliriumTremex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DeliriumTremex.hello
      :world

  """
  def hello do
    :world
  end

  def wrap_list(nil), do: []
  def wrap_list(item) when is_list(item), do: item
  def wrap_list(item), do: [item]
end
