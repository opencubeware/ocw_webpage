defmodule OcwWebpage.Services.Tournaments do
  alias FE.Result
  alias OcwWebpage.DataAccess
  alias OcwWebpage.Model

  @spec fetch_round(String.t(), String.t(), String.t()) :: Result.t(map())
  def fetch_round(tournament_name, event_name, round_name) do
    DataAccess.Round.fetch(tournament_name, event_name, round_name)
    |> Result.map(&Model.Round.to_map/1)
  end

  @spec fetch_event_with_rounds(String.t()) :: map()
  def fetch_event_with_rounds(tournament_name) do
    DataAccess.TournamentEventsNamesWithRoundNames.fetch(tournament_name)
    |> Result.map(&Model.EventsNamesWithRoundNames.to_map/1)
    |> Result.unwrap!()
  end
end
