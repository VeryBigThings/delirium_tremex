defmodule DeliriumTremex.ErrorBuilder do
  def unauthorized do
    %{
      message: "You have insufficient privileges to access this resource",
      messages: ["You have insufficient privileges to access this resource"]
    }
  end
end
