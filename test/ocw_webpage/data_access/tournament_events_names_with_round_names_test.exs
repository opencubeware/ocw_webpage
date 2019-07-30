defmodule OcwWebpage.DataAccess.TournamentEventsNamesWithRoundNamesTest do
  use OcwWebpage.DataCase

  alias OcwWebpage.{DataAccess, Model, Repo}

  alias OcwWebpage.Constants.{RoundName, EventName}

  alias OcwWebpage.DataAccess.Schemas.{
    Round,
    Event,
    Tournament
  }

  describe "fetch/1" do
    test "fetches correct events with round names" do
      tournament_name = "Cracow Open 2013"
      event_name_1 = "3x3x3"
      event_name_2 = "2x2x2"
      round_name_1 = "First Round"
      round_name_2 = "Second Round"

      event_name_db_1 = Repo.get(EventName, 1)
      event_name_db_2 = Repo.get(EventName, 2)
      round_name_db_1 = Repo.get(RoundName, 1)
      round_name_db_2 = Repo.get(RoundName, 2)
      tournament = Repo.insert!(%Tournament{name: tournament_name, country_id: 141})
      event_1 = Repo.insert!(%Event{event_name: event_name_db_1, tournament: tournament})
      event_2 = Repo.insert!(%Event{event_name: event_name_db_2, tournament: tournament})
      Repo.insert!(%Round{round_name: round_name_db_1, event: event_1})
      Repo.insert!(%Round{round_name: round_name_db_2, event: event_1})
      Repo.insert!(%Round{round_name: round_name_db_1, event: event_2})
      Repo.insert!(%Round{round_name: round_name_db_2, event: event_2})

      assert {:ok,
              %Model.EventsNamesWithRoundNames{
                events: [
                  %{name: ^event_name_1, round_names: [^round_name_1, ^round_name_2]},
                  %{name: ^event_name_2, round_names: [^round_name_1, ^round_name_2]}
                ]
              }} = DataAccess.TournamentEventsNamesWithRoundNames.fetch(tournament_name)
    end
  end
end
