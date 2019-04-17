defmodule DeliriumTremex.Formatters.Ecto.ChangesetTest do
  use ExUnit.Case
  doctest DeliriumTremex
  alias DeliriumTremex.Formatters.Ecto.Changeset

  describe "nested changeset formatting" do
    test "error nested inside map returns error inside suberrors list" do
      data = {:address, %{address_line1: [{"can't be blank", [validation: :required]}]}}

      formatted_data = Changeset.format(data)

      assert formatted_data[:suberrors] == [
               %{
                 full_messages: ["Address_line1 can't be blank"],
                 index: nil,
                 key: :address_line1,
                 message: "Address_line1 can't be blank",
                 messages: ["can't be blank"],
                 suberrors: nil
               }
             ]
    end

    test "error nested inside list of maps returns error inside nested suberrors list" do
      data =
        {:comments,
         [
           %{
             user_id: [
               {"does not exist",
                [
                  constraint: :foreign,
                  constraint_name: "comments_user_id_fkey"
                ]}
             ]
           },
           %{}
         ]}

      formatted_data = Changeset.format(data)

      assert formatted_data == [
               message: "Comments errors",
               key: :comments,
               messages: nil,
               full_messages: nil,
               index: nil,
               suberrors: [
                 %{
                   full_messages: ["User_id does not exist"],
                   index: nil,
                   key: :user_id,
                   message: "User_id does not exist",
                   messages: ["does not exist"],
                   suberrors: nil
                 }
               ]
             ]
    end
  end
end
