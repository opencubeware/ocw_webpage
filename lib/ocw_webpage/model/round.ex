defmodule OcwWebpage.Model.Round do
  alias OcwWebpage.Model
  defstruct [:id, :event_name, :name, :cutoff, :format, :results, :tournament_name]

  @type t :: %__MODULE__{
          event_name: String.t(),
          name: String.t(),
          results: [Model.Result.t()],
          cutoff: integer | nil,
          format: String.t(),
          tournament_name: String.t()
        }

  @spec new(%{
          id: integer,
          event: %{event_name: %{name: String.t()}, tournament: %{name: String.t()}},
          results: map(),
          cutoff: integer | nil,
          format: String.t(),
          round_name: %{name: String.t()}
        }) :: t()
  def new(%{
        id: id,
        event: %{event_name: %{name: event_name}, tournament: %{name: tournament_name}},
        round_name: %{name: round_name},
        cutoff: cutoff,
        format: format,
        results: results
      }) do
    struct(__MODULE__, %{
      id: id,
      event_name: event_name,
      name: round_name,
      cutoff: cutoff,
      format: format,
      tournament_name: tournament_name,
      results: Enum.map(results, &Model.Result.new/1)
    })
  end

  @spec to_map(t()) :: %{
          id: integer,
          event_name: String.t(),
          name: String.t(),
          results: [map()],
          cutoff: integer | nil,
          tournament_name: String.t()
        }
  def to_map(%__MODULE__{
        id: id,
        event_name: event_name,
        name: name,
        results: results,
        cutoff: cutoff,
        format: format,
        tournament_name: tournament_name
      }) do
    %{
      id: id,
      name: name,
      event_name: event_name,
      tournament_name: tournament_name,
      results: map_results(results),
      format: map_round_format(format),
      cutoff: Model.Result.format_time(cutoff)
    }
  end

  defp map_results(results) do
    results
    |> Enum.map(&Model.Result.to_map/1)
    |> Enum.sort_by(fn map -> {map.average, map.best_solve} end)
  end

  def map_round_format("ao5"), do: "Average of 5"
  def map_round_format("mo3"), do: "Mean of 3"
  def map_round_format("bo2/ao5"), do: "Best of 2/Average of 5"
  def map_round_format("bo1/mo3"), do: "Best of 1/Mean of 3"
  def map_round_format("bo1"), do: "Best of 1"
  def map_round_format("Average of 5"), do: :ao5
  def map_round_format("Mean of 3"), do: :mo3
  def map_round_format("Best of 2/Average of 5"), do: :bo2_ao5
  def map_round_format("Best of 1/Mean of 3"), do: :bo1_mo3
  def map_round_format("Best of 1"), do: :bo1
end
