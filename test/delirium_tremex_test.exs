defmodule DeliriumTremexTest do
  use ExUnit.Case
  doctest DeliriumTremex

  test "format unknown error" do
    map = DeliriumTremex.Middleware.HandleErrors.call(%{errors: [:this_error_is_not_recognised], state: :resolved}, %{})
    assert hd(map[:errors])[:key] == :unknown_error
  end

  test "format error with error builder" do
    map = DeliriumTremex.Middleware.HandleErrors.call(%{errors: [:unauthorized], state: :resolved}, %{})
    assert hd(map[:errors])[:key] == :unauthorized
  end

  test "format changeset error without ecto dependency as an unknown error" do
    error_cs = %Ecto.Testset{valid?: false, changes: %{foo: "bar"}}

    map = DeliriumTremex.Middleware.HandleErrors.call(%{errors: [error_cs], state: :resolved}, %{})

    assert hd(map[:errors])[:key] == :unknown_error
  end
end
