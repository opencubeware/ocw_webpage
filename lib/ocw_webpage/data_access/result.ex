defmodule OcwWebpage.DataAccess.Result do
  import Ecto.Query, only: [from: 2]
  alias OcwWebpage.{Repo, DataAccess.Schemas, Model, Constants}

  @spec get(String.t()) :: FE.Result.t()
  def get(index) do
    from(r in Schemas.Result, where: r.id == ^index, preload: [person: [country: [:continent]]])
    |> Repo.all()
    |> empty_or_not()
    |> FE.Result.map(&Model.Result.new/1)
  end

  @spec fetch_filtered_by_name(String.t(), String.t(), String.t(), String.t()) ::
          list(Model.Result.t())
  def fetch_filtered_by_name(tournament_name, event_name, round_name, query) do
    query_string = "%#{query}%"

    from(res in Schemas.Result,
      join: r in Schemas.Round,
      on: res.round_id == r.id,
      join: e in Schemas.Event,
      on: r.event_id == e.id,
      join: rn in Constants.RoundName,
      on: r.round_name_id == rn.id,
      join: en in Constants.EventName,
      on: e.event_name_id == en.id,
      join: t in Schemas.Tournament,
      on: t.id == e.tournament_id,
      join: p in Schemas.Person,
      on: p.id == res.competitor_id,
      where:
        rn.name == ^round_name and en.name == ^event_name and t.name == ^tournament_name and
          (fragment("lower(?) like lower(?)", p.first_name, ^query_string) or
             fragment("lower(?) like lower(?)", p.last_name, ^query_string)),
      preload: [
        person: [country: [:continent]]
      ]
    )
    |> Repo.all()
    |> Enum.map(&Model.Result.new/1)
  end

  @spec update_times_in_db(Model.Result.t()) :: %Schemas.Result{}
  def update_times_in_db(model) do
    Schemas.Result
    |> Repo.get(model.id)
    |> Ecto.Changeset.change(%{attempts: model.attempts, average: model.average})
    |> Repo.update()
  end

  @spec validate_and_transform_params(map()) :: FE.Result.t(list(integer))
  def validate_and_transform_params(%{
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        id: id
      }) do
    list =
      [first, second, third, fourth, fifth]
      |> Enum.map(&maybe_replace_empty_string_with_zero/1)

    case Enum.any?(list, fn x -> Integer.parse(x) == :error end) do
      false ->
        attempts =
          list
          |> Enum.map(&String.to_integer/1)
          |> Enum.map(&maybe_replace_zero_with_no_change/1)

        {:ok, %{attempts: attempts, id: id}}

      true ->
        {:error, :param_not_integer}
    end
  end

  defp maybe_replace_empty_string_with_zero(string) when string == "", do: "0"
  defp maybe_replace_empty_string_with_zero(string), do: string

  defp maybe_replace_zero_with_no_change(0), do: :no_change
  defp maybe_replace_zero_with_no_change(integer), do: integer

  defp empty_or_not(list) do
    case list do
      [] -> {:error, 404}
      [element] -> {:ok, element}
    end
  end
end
