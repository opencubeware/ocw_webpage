defmodule OcwWebpage.Model.EventsNamesWithRoundNamesTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Model.EventsNamesWithRoundNames

  describe "new/1" do
    test "returns EventsNamesWithRoundNames.t()" do
      event_name = "3x3x3"
      name = "First Round"
      round_name = %{name: name}

      events = [
        %{
          event_name: %{name: event_name},
          rounds: [
            %{round_name: %{name: name}}
          ]
        }
      ]

      assert %EventsNamesWithRoundNames{
               events: [
                 %{
                   name: ^event_name,
                   round_names: [^name]
                 }
               ]
             } = EventsNamesWithRoundNames.new(%{events: events})
    end
  end

  describe "to_map/1" do
    test "returns propper map from struct" do
      event_name = "3x3x3"
      name = "First Round"

      struct = %EventsNamesWithRoundNames{
        events: [
          %{
            name: event_name,
            round_names: [name]
          }
        ]
      }

      assert %{
               events: [
                 %{
                   name: ^event_name,
                   round_names: [^name]
                 }
               ]
             } = EventsNamesWithRoundNames.to_map(struct)
    end
  end
end
