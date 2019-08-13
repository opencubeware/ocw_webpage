defmodule OcwWebpage.Services.TournamentsTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Services

  describe "fetch_round/3" do
    setup do
      tournament_name = "Cracow Open 2013"
      event_name = "3x3x3"
      round_name = "First Round"

      event = insert(:event)
      round = insert(:round, event: event)
      insert(:result, round: round)

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
                    attempts: ["00:05.90", "00:03.90", "00:04.90", "00:09.00", "00:06.90"],
                    average: "00:05.90",
                    best_solve: "00:03.90",
                    competitor: %{
                      country: %{
                        continent_name: "Europe",
                        iso2: "pl",
                        name: "Poland"
                      },
                      first_name: "Kamil",
                      last_name: "Zielinski",
                      wca_id: "2009Zieli"
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

      tournament = insert(:tournament)
      event_1 = insert(:event, event_name_id: 1, tournament: tournament)
      event_2 = insert(:event, event_name_id: 2, tournament: tournament)
      insert(:round, round_name_id: 1, event: event_1)
      insert(:round, round_name_id: 2, event: event_1)
      insert(:round, round_name_id: 1, event: event_2)
      insert(:round, round_name_id: 2, event: event_2)

      assert {:ok,
              %{
                events: [
                  %{name: ^event_name_1, round_names: [^round_name_1, ^round_name_2]},
                  %{name: ^event_name_2, round_names: [^round_name_1, ^round_name_2]}
                ]
              }} = Services.Tournaments.fetch_event_with_rounds(tournament_name)
    end

    test "returns error when not found" do
      assert {:error, 404} = Services.Tournaments.fetch_event_with_rounds("wrong_tournament")
    end
  end

  describe "fetch_result/1" do
    test "fetches proper map result when found" do
      result = insert(:result)
      result_id = Integer.to_string(result.id)

      assert {:ok,
              %{
                attempts: ["00:05.90", "00:03.90", "00:04.90", "00:09.00", "00:06.90"],
                average: "00:05.90",
                best_solve: "00:03.90",
                competitor: %{
                  country: %{continent_name: "Europe", iso2: "pl", name: "Poland"},
                  first_name: "Kamil",
                  last_name: "Zielinski",
                  wca_id: "2009Zieli"
                },
                id: _id
              }} = Services.Tournaments.fetch_result(result_id)
    end

    test "returns error when not found" do
      assert {:error, 404} = Services.Tournaments.fetch_result("3")
    end
  end

  describe "fetch_filtered_results/4" do
    setup do
      %{
        tournament_name: "Cracow Open 2013",
        round_name: "First Round",
        event_name: "3x3x3",
        query: "ziel"
      }
    end

    test "return list of proper maps filtered by query", params do
      insert(:result)

      assert [%{competitor: %{last_name: "Zielinski"}}] =
               Services.Tournaments.fetch_filtered_results(
                 params.tournament_name,
                 params.event_name,
                 params.round_name,
                 params.query
               )
    end

    test "return empty list of when nothing is found", params do
      assert [] =
               Services.Tournaments.fetch_filtered_results(
                 params.tournament_name,
                 params.event_name,
                 params.round_name,
                 params.query
               )
    end
  end
end
