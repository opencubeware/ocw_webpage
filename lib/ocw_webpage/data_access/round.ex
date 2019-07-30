defmodule OcwWebpage.DataAccess.Round do
  import Ecto.Query, only: [from: 2]
  alias FE.Result
  alias OcwWebpage.DataAccess.Schemas
  alias OcwWebpage.Repo
  alias OcwWebpage.Constants
  alias OcwWebpage.Model

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(OcwWebpage.PubSub, @topic)
  end

  def update_testing() do
    OcwWebpage.Repo.get(OcwWebpage.DataAccess.Schemas.Result, 1)
    |> Ecto.Changeset.change(%{attempts: for(_ <- 1..5, do: Enum.random(100..800))})
    |> OcwWebpage.Repo.update()
    |> broadcast_change([:round, :updated])
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(OcwWebpage.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  @spec fetch(String.t(), String.t(), String.t()) :: Result.t(Model.Round.t())
  def fetch(tournament_name, event_name, round_name) do
    full_round_query(tournament_name, event_name, round_name)
    |> Repo.all()
    |> empty_or_not()
    |> Result.map(&Model.Round.new/1)
  end

  defp full_round_query(tournament_name, event_name, round_name) do
    from(r in Schemas.Round,
      join: e in Schemas.Event,
      on: r.event_id == e.id,
      join: rn in Constants.RoundName,
      on: r.round_name_id == rn.id,
      join: en in Constants.EventName,
      on: e.event_name_id == en.id,
      join: t in Schemas.Tournament,
      on: t.id == e.tournament_id,
      where: rn.name == ^round_name and en.name == ^event_name and t.name == ^tournament_name,
      preload: [
        event: [:event_name, :tournament],
        round_name: [],
        results: [person: [country: [:continent]]]
      ]
    )
  end

  defp empty_or_not(rounds) do
    case rounds do
      [] -> {:error, 404}
      [round] -> {:ok, round}
    end
  end
end
