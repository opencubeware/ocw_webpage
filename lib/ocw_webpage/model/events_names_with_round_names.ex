defmodule OcwWebpage.Model.EventsNamesWithRoundNames do
  defstruct([:events])

  @type t :: %__MODULE__{
          events: [
            %{
              name: String.t(),
              round_names: [String.t()]
            }
          ]
        }

  @spec new(%{events: [map()]}) :: FE.Result.t(t())
  def new(%{events: events}) do
    {:ok, struct(__MODULE__, %{events: events_names_with_rounds_names(events)})}
  end

  @spec to_map(t()) :: map()
  def to_map(struct), do: Map.from_struct(struct)

  defp events_names_with_rounds_names(events) do
    Enum.map(events, fn event ->
      %{
        name: event.event_name.name,
        round_names: Enum.map(event.rounds, fn %{round_name: %{name: name}} -> name end)
      }
    end)
  end
end
