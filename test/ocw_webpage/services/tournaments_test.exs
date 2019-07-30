defmodule OcwWebpage.Services.TournamentsTest do
  use OcwWebpage.DataCase

  alias OcwWebpage.Services

  alias OcwWebpage.Repo

  alias OcwWebpage.Constants.{RoundName, EventName}

  alias OcwWebpage.DataAccess.Schemas.{
    Round,
    Event,
    Person,
    Tournament,
    Result
  }

  describe "fetch_round/3" do
    setup do
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

      %{tournament_name: tournament_name, event_name: event_name, round_name: round_name}
    end

    test "fetches everything correctly", %{
      tournament_name: tournament_name,
      event_name: event_name,
      round_name: round_name
    } do
      assert {:ok,
              %{
                event_name: "3x3x3",
                name: "First Round",
                results: [
                  %{
                    attempts: ["00:05.10", "00:06.20", "00:07.30", "00:05.80", "00:07.40"],
                    average: "00:06.36",
                    best_solve: "00:05.10",
                    competitor: %{
                      country: %{
                        continent_name: "Europe",
                        iso2: "gb",
                        name: "United Kingdom"
                      },
                      first_name: "John",
                      last_name: "Doe",
                      wca_id: "2018dupa"
                    }
                  }
                ],
                tournament_name: "Cracow Open 2013"
              }} = Services.Tournaments.fetch_round(tournament_name, event_name, round_name)
    end

    test "returns error when not found", %{
      tournament_name: tournament_name,
      event_name: event_name,
      round_name: round_name
    } do
      assert {:error, 404} =
               Services.Tournaments.fetch_round(tournament_name, event_name, "wrong_round")

      assert {:error, 404} =
               Services.Tournaments.fetch_round(tournament_name, "wrong_event", round_name)

      assert {:error, 404} =
               Services.Tournaments.fetch_round("wrong_tournament", event_name, round_name)
    end
  end

  describe "fetch_event_with_rounds/1" do
    test "fetches everything correctly" do
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

      %{
        events: [
          %{name: ^event_name_1, round_names: [^round_name_1, ^round_name_2]},
          %{name: ^event_name_2, round_names: [^round_name_1, ^round_name_2]}
        ]
      } = Services.Tournaments.fetch_event_with_rounds(tournament_name)
    end
  end
end
