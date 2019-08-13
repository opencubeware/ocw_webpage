defmodule OcwWebpage.Services.Tournaments do
  alias FE.Result
  alias OcwWebpage.DataAccess
  alias OcwWebpage.Model

  @spec fetch_round(String.t(), String.t(), String.t()) :: Result.t(map())
  def fetch_round(tournament_name, event_name, round_name) do
    DataAccess.Round.fetch(tournament_name, event_name, round_name)
    |> Result.map(&Model.Round.to_map/1)
  end

  def fetch_filtered_results(tournament_name, event_name, round_name, query) do
    DataAccess.Result.fetch_filtered_by_name(tournament_name, event_name, round_name, query)
    |> Enum.map(&Model.Result.to_map/1)
  end

  @spec fetch_event_with_rounds(String.t()) :: Result.t(map())
  def fetch_event_with_rounds(tournament_name) do
    DataAccess.TournamentEventsNamesWithRoundNames.fetch(tournament_name)
    |> Result.map(&Model.EventsNamesWithRoundNames.to_map/1)
  end

  @spec fetch_result(String.t()) :: Result.t(map())
  def fetch_result(index) do
    DataAccess.Result.get(index)
    |> Result.map(&Model.Result.to_map/1)
  end

  @spec update_result(map()) :: Result.t(map())
  def update_result(params) do
    with {:ok, %{attempts: attempts} = valid_params} =
           DataAccess.Result.validate_and_transform_params(params) do
      Model.Result.new(valid_params)
      |> Result.map(&Model.Result.update_attempts(&1, attempts))
      |> Result.map(&Model.Result.calculate_average/1)
      |> Result.and_then(&DataAccess.Result.update_times_in_db/1)
    end
  end
end
