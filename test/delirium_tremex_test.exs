defmodule DeliriumTremexTest do
  use ExUnit.Case
  doctest DeliriumTremex

  test "format unknown error" do
    map = DeliriumTremex.Middleware.HandleErrors.call(%{errors: [:unauthorized], state: :resolved}, %{})
    assert hd(map[:errors])[:key] == :unknown_error
  end
end
