defmodule DeliriumTremex.ErrorBuilder do
  def unauthorized() do
    %{
      code: :unauthorized,
      key: :current_account,
      message: "The current account is unauthorized for this action",
      messages: ["unauthorized"]
    }
  end
end