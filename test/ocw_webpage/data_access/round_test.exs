defmodule OcwWebpage.DataAccess.RoundTest do
  use OcwWebpage.DataCase

  alias OcwWebpage.{DataAccess, Model, Repo}

  alias OcwWebpage.Constants.{RoundName, EventName}

  alias OcwWebpage.DataAccess.Schemas.{
    Round,
    Event,
    Person,
    Tournament,
    Result
  }

  describe "fetch/3" do
    test "fetches correct round" do
      tournament_name = "Cracow Open 2013"
      event_name = "3x3x3"
      round_name = "First Round"

      person =
        Repo.insert!(%Person{
          first_name: "John",
          last_name: "Doe",
          wca_id: "2018dupa",
          country_id: 190
        })

      event_name_db = Repo.get(EventName, 1)
      round_name_db = Repo.get(RoundName, 1)
      tournament = Repo.insert!(%Tournament{name: tournament_name, country_id: 141})
      event = Repo.insert!(%Event{event_name: event_name_db, tournament: tournament})
      round = Repo.insert!(%Round{round_name: round_name_db, event: event})

      Repo.insert(%Result{
        round: round,
        attempts: [510, 620, 730, 580, 740],
        average: 636,
        competitor_id: person.id
      })

      assert {:ok, %Model.Round{}} =
               DataAccess.Round.fetch(tournament_name, event_name, round_name)
    end
  end
end
