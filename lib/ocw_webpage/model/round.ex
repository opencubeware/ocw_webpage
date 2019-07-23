defmodule OcwWebpage.Model.Round do
  @derive Jason.Encoder
  alias OcwWebpage.Model
  defstruct [:event_name, :name, :results, :tournament_name]

  @type t :: %__MODULE__{
          event_name: String.t(),
          name: String.t(),
          results: [Model.Result.t()],
          tournament_name: String.t()
        }

  @spec new(%{
          event: %{event_name: %{name: String.t()}, tournament: %{name: String.t()}},
          results: map(),
          round_name: %{name: String.t()}
        }) :: FE.Result.t(t(), String.t())
  def new(%{
        event: %{event_name: %{name: event_name}, tournament: %{name: tournament_name}},
        round_name: %{name: round_name},
        results: results
      }) do
    FE.Result.ok(
      struct(__MODULE__, %{
        event_name: event_name,
        name: round_name,
        tournament_name: tournament_name,
        results: Enum.map(results, &Model.Result.new/1)
      })
    )
  end

  @spec to_map(t()) :: %{
          event_name: String.t(),
          name: String.t(),
          results: [map()],
          tournament_name: String.t()
        }
  def to_map(%__MODULE__{
        event_name: event_name,
        name: name,
        results: results,
        tournament_name: tournament_name
      }) do
    %{
      name: name,
      event_name: event_name,
      tournament_name: tournament_name,
      results: map_results(results)
    }
  end

  defp map_results(results) do
    results
    |> Enum.map(&Model.Result.to_map/1)
    |> Enum.sort_by(fn map -> {map.average, map.best_solve} end)
  end
end
