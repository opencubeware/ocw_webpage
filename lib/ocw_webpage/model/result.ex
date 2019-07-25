defmodule OcwWebpage.Model.Result do
  alias OcwWebpage.Model
  defstruct [:attempts, :average, :competitor]

  @type t :: %__MODULE__{
          attempts: [integer()],
          average: integer(),
          competitor: Model.Person.t()
        }

  @spec new(%{
          attempts: [integer()],
          average: integer(),
          person: %{
            country: map(),
            first_name: String.t(),
            last_name: String.t(),
            wca_id: String.t()
          }
        }) :: t()
  def new(%{attempts: attempts, average: average, person: competitor}) do
    competitor = Model.Person.new(competitor)
    struct(__MODULE__, %{attempts: attempts, average: average, competitor: competitor})
  end

  @spec to_map(t()) :: %{
          attempts: [String.t()],
          average: String.t(),
          best_solve: String.t(),
          competitor: map()
        }
  def to_map(%{attempts: attempts, average: average, competitor: competitor}) do
    %{
      attempts: Enum.map(attempts, &format_time/1),
      best_solve: Enum.min(attempts) |> format_time(),
      average: average |> format_time(),
      competitor: Model.Person.to_map(competitor)
    }
  end

  @spec format_time(integer) :: String.t()
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

  # defp calculate_average(attempts) do
  #   case Enum.count(attempts) < 5 do
  #     true ->
  #       nil

  #     false ->
  #       {min, max} = Enum.min_max(attempts)
  #       remaining_attempts = Enum.filter(attempts, fn x -> x != min and x != max end)
  #       Enum.reduce(remaining_attempts, fn x, acc -> x + acc end) / Enum.count(remaining_attempts)
  #   end
  # end
end
