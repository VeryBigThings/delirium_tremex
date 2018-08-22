defmodule DeliriumTremex.ErrorBuilder do
  def errors() do
    %{
      unauthorized: %{
        key: :unauthorized,
        message: "You have insufficient privileges to access this resource",
        messages: ["You have insufficient privileges to access this resource"]
      }
    }
  end
end
