defmodule OcwWebpage.Model.Result do
  alias OcwWebpage.Model
  defstruct [:id, :attempts, :best_solve, :average, :competitor]

  @type t :: %__MODULE__{
          id: integer(),
          attempts: [FE.Maybe.t(integer)],
          best_solve: FE.Maybe.t(integer),
          average: FE.Maybe.t(integer),
          competitor: Model.Person.t()
        }

  @spec new(%{
          id: integer(),
          attempts: [integer()],
          average: integer | nil,
          person: %{
            country: map(),
            first_name: String.t(),
            last_name: String.t(),
            wca_id: String.t()
          }
        }) :: t()
  def new(%{id: id, attempts: attempts, average: average, person: competitor}) do
    competitor = Model.Person.new(competitor)

    struct(__MODULE__, %{
      id: id,
      attempts: attempts |> Enum.map(&FE.Maybe.new/1),
      average: FE.Maybe.new(average),
      best_solve: attempts |> format_best_solve() |> FE.Maybe.new(),
      competitor: competitor
    })
  end

  @spec to_map(t()) :: %{
          id: integer,
          attempts: [String.t()],
          average: String.t(),
          best_solve: String.t(),
          competitor: map()
        }
  def to_map(%{
        id: id,
        attempts: attempts,
        average: average,
        best_solve: best_solve,
        competitor: competitor
      }) do
    %{
      id: id,
      attempts: attempts |> Enum.map(&format_time/1),
      best_solve: best_solve |> format_time(),
      average: average |> format_time(),
      competitor: Model.Person.to_map(competitor)
    }
  end

  defp format_best_solve([]), do: nil
  defp format_best_solve(attempts) when is_list(attempts), do: attempts |> Enum.min()

  @spec format_time(integer | FE.Maybe.t(integer)) :: String.t()
  def format_time(:nothing), do: ""
  def format_time({:just, average}), do: format_time(average)

  def format_time(centiseconds) when is_integer(centiseconds) do
    "#{minutes(centiseconds)}:#{seconds(centiseconds)}.#{remains(centiseconds)}"
  end

  defp minutes(centiseconds) do
    centiseconds
    |> div(100)
    |> div(60)
    |> add_zero_if_needed()
  end

  defp seconds(centiseconds) do
    centiseconds
    |> div(100)
    |> discard_full_minutes()
    |> add_zero_if_needed()
  end

  defp remains(centiseconds) do
    centiseconds
    |> rem(100)
    |> add_zero_if_needed()
  end

  defp discard_full_minutes(time) when time >= 60, do: time - div(time, 60) * 60
  defp discard_full_minutes(time), do: time

  defp add_zero_if_needed(time) when time < 10, do: "0#{time}"
  defp add_zero_if_needed(time), do: "#{time}"

  @spec calculate_average(t(), atom()) :: t()
  def calculate_average(%__MODULE__{attempts: attempts} = model, type) do
    calculate_average(model, type, Enum.any?(attempts, &(&1 == FE.Maybe.nothing())))
  end

  defp calculate_average(model, _type, true), do: %__MODULE__{model | average: FE.Maybe.nothing()}

  defp calculate_average(%__MODULE__{attempts: attempts} = model, :mo3, false) do
    mean = attempts |> Enum.sum() |> div(length(attempts))
    %__MODULE__{model | average: mean}
  end

  defp calculate_average(model, :ao5, false) do
    calculate_average_of_five(model)
  end

  defp calculate_average_of_five(%__MODULE__{attempts: attempts} = model)
       when length(attempts) >= 3 do
    remaining_attempts =
      attempts
      |> Enum.min_max()
      |> filter_min_max(attempts)

    average =
      remaining_attempts
      |> Enum.sum()
      |> div(length(remaining_attempts))

    %__MODULE__{model | average: average}
  end

  defp calculate_average_of_five(model), do: model

  defp filter_min_max({min, max}, attempts) do
    Enum.filter(attempts, fn x -> x != min and x != max end)
  end

  @spec update_attempts(__MODULE__.t(), list(FE.Maybe.t(integer))) ::
          FE.Result.t(__MODULE__.t(), :not_an_array)
  def update_attempts(model, attempts) when is_list(attempts) do
    updated_attempts =
      model
      |> Map.get(:attempts)
      |> Enum.zip(attempts)
      |> Enum.map(&change_requested/1)

    %__MODULE__{model | attempts: updated_attempts}
  end

  def update_attempts(_model, _attempts), do: {:error, :not_an_array}

  defp change_requested({x, y}) when y == :nothing, do: x
  defp change_requested({_x, y}), do: y
end
