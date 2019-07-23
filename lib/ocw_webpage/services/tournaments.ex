defmodule OcwWebpage.Services.Tournaments do
  alias OcwWebpage.DataAccess
  alias OcwWebpage.Model

  @spec fetch_round(String.t(), String.t(), String.t()) :: map()
  def fetch_round(tournament_name, event_name, round_name) do
    DataAccess.Round.fetch(tournament_name, event_name, round_name)
    |> FE.Result.map(&Model.Round.to_map/1)
    |> FE.Result.unwrap!()
  end

  @spec fetch_event_with_rounds(String.t()) :: map()
  def fetch_event_with_rounds(tournament_name) do
    DataAccess.TournamentEventsNamesWithRoundNames.fetch(tournament_name)
    |> FE.Result.map(&Model.EventsNamesWithRoundNames.to_map/1)
    |> FE.Result.unwrap!()
  end
end
