defmodule OcwWebpage.DataAccess.TournamentEventsNamesWithRoundNames do
  import Ecto.Query, only: [from: 2]
  alias FE.Result
  alias OcwWebpage.DataAccess.Schemas
  alias OcwWebpage.Repo
  alias OcwWebpage.Model

  @spec fetch(String.t()) :: Result.t(Model.EventsNamesWithRoundNames.t())
  def fetch(tournament_name) do
    event_with_rounds(tournament_name)
    |> Repo.all()
    |> empty_or_not()
    |> Result.map(&Model.EventsNamesWithRoundNames.new/1)
  end

  defp event_with_rounds(tournament_name) do
    from(t in Schemas.Tournament,
      where: t.name == ^tournament_name,
      preload: [events: [event_name: [], rounds: [:round_name]]]
    )
  end

  defp empty_or_not(tournaments) do
    case tournaments do
      [] -> {:error, 404}
      [tournaments] -> {:ok, tournaments}
    end
  end
end
