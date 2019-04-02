defmodule DeliriumTremex.Formatters.Ecto.ChangesetTest do
  use ExUnit.Case
  doctest DeliriumTremex

  describe "nested changeset formatting" do
    test "error nested inside map returns error inside suberrors list" do
      data = {:foo, %{bar: [{"can't be blank", [validation: :required]}]}}

      formatted_data = DeliriumTremex.Formatters.Ecto.Changeset.format(data)

      assert formatted_data[:suberrors] == [
               %{
                 full_messages: ["Bar can't be blank"],
                 index: nil,
                 key: :bar,
                 message: "Bar can't be blank",
                 messages: ["can't be blank"],
                 suberrors: nil
               }
             ]
    end

    test "error nested inside list of maps returns error inside nested suberrors list" do
      data =
        {:foos,
         [
           %{
             bar_id: [
               {"does not exist",
                [
                  constraint: :foreign,
                  constraint_name: "foos_bar_id_fkey"
                ]}
             ]
           },
           %{}
         ]}

      formatted_data = DeliriumTremex.Formatters.Ecto.Changeset.format(data)

      assert formatted_data[:suberrors] == [
               %{
                 full_messages: nil,
                 index: nil,
                 key: :foos,
                 message: "Foos errors",
                 messages: nil,
                 suberrors: [
                   %{
                     full_messages: ["Bar_id does not exist"],
                     index: nil,
                     key: :bar_id,
                     message: "Bar_id does not exist",
                     messages: ["does not exist"],
                     suberrors: nil
                   }
                 ]
               }
             ]
    end
  end
end
