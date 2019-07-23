defmodule OcwWebpage.DataAccess.TournamentEventsNamesWithRoundNames do
  import Ecto.Query, only: [from: 2]
  alias OcwWebpage.DataAccess.Schemas
  alias OcwWebpage.Repo
  alias OcwWebpage.Model

  @spec fetch(String.t()) :: Result.t(Model.EventWithRoundNames.t())
  def fetch(tournament_name) do
    event_with_rounds(tournament_name)
    |> Repo.all()
    |> FE.Result.ok()
    |> FE.Result.map(fn [tournament] -> tournament end)
    |> FE.Result.and_then(&Model.EventsNamesWithRoundNames.new/1)
  end

  defp event_with_rounds(tournament_name) do
    from(t in Schemas.Tournament,
      where: t.name == ^tournament_name,
      preload: [events: [event_name: [], rounds: [:round_name]]]
    )
  end
end
