defmodule OcwWebpage.Model.Result do
  alias OcwWebpage.Model
  defstruct [:id, :attempts, :average, :competitor]

  @type t :: %__MODULE__{
          id: integer(),
          attempts: [integer()],
          average: integer(),
          competitor: Model.Person.t()
        }

  @spec new(%{
          id: integer(),
          attempts: [integer()],
          average: integer(),
          person: %{
            country: map(),
            first_name: String.t(),
            last_name: String.t(),
            wca_id: String.t()
          }
        }) :: t()
  def new(%{id: id, attempts: attempts, average: average, person: competitor}) do
    competitor = Model.Person.new(competitor)
    struct(__MODULE__, %{id: id, attempts: attempts, average: average, competitor: competitor})
  end

  @spec to_map(t()) :: %{
          id: integer(),
          attempts: [String.t()],
          average: String.t(),
          best_solve: String.t(),
          competitor: map()
        }
  def to_map(%{id: id, attempts: attempts, average: average, competitor: competitor}) do
    %{
      id: id,
      attempts: Enum.map(attempts, &format_time/1),
      best_solve: Enum.min(attempts) |> format_time(),
      average: average |> format_time(),
      competitor: Model.Person.to_map(competitor)
    }
  end

  @spec format_time(integer | nil) :: String.t()
  def format_time(nil), do: ""

  def format_time(centiseconds) do
    "#{minutes(centiseconds)}:#{seconds(centiseconds)}.#{remains(centiseconds)}"
  end

  defp minutes(centiseconds) do
    div(centiseconds, 100)
    |> div(60)
    |> add_zero_if_needed()
  end

  defp seconds(centiseconds) do
    div(centiseconds, 100)
    |> discard_full_minutes()
    |> add_zero_if_needed()
  end

  defp remains(centiseconds) do
    rem(centiseconds, 100)
    |> add_zero_if_needed()
  end

  defp discard_full_minutes(time) when time >= 60, do: time - div(time, 60) * 60
  defp discard_full_minutes(time), do: time

  defp add_zero_if_needed(time) when time < 10, do: "0#{time}"
  defp add_zero_if_needed(time), do: "#{time}"

  @spec calculate_average(t()) :: t()
  def calculate_average(%__MODULE__{attempts: attempts} = model) when length(attempts) >= 3 do
    remaining_attempts =
      Enum.min_max(attempts)
      |> filter_min_max(attempts)

    average =
      Enum.sum(remaining_attempts)
      |> div(length(remaining_attempts))

    %__MODULE__{model | average: average}
  end

  def calculate_average(model), do: model

  defp filter_min_max({min, max}, attempts) do
    Enum.filter(attempts, fn x -> x != min and x != max end)
  end

  # no dot notation to centiseconds
  # 124354 - div(124354, 10000) * 4000
end
