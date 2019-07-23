defmodule OcwWebpage.Model.Result do
  @derive Jason.Encoder
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
      attempts: Enum.map(attempts, &convert_to_tournament_time_format/1),
      best_solve: Enum.min(attempts) |> convert_to_tournament_time_format(),
      average: average |> convert_to_tournament_time_format(),
      competitor: Model.Person.to_map(competitor)
    }
  end

  defp convert_to_tournament_time_format(centiseconds) when centiseconds / 100 < 10 do
    "00:0#{float_to_binary(centiseconds)}"
  end

  defp convert_to_tournament_time_format(centiseconds)
       when centiseconds / 100 >= 10 and centiseconds / 100 < 60 do
    "00:#{float_to_binary(centiseconds)}"
  end

  defp convert_to_tournament_time_format(centiseconds)
       when centiseconds / 100 >= 60 and centiseconds / 100 < 600 do
    {minutes, remaining_centiseconds} = to_minutes_and_seconds(centiseconds)

    case remaining_centiseconds / 100 < 10 do
      true ->
        "0#{minutes}:0#{float_to_binary(remaining_centiseconds)}"

      false ->
        "0#{minutes}:#{float_to_binary(remaining_centiseconds)}"
    end
  end

  defp convert_to_tournament_time_format(centiseconds)
       when centiseconds / 100 >= 600 and centiseconds / 100 < 3600 do
    {minutes, remaining_centiseconds} = to_minutes_and_seconds(centiseconds)

    case remaining_centiseconds / 100 < 10 do
      true ->
        "#{minutes}:0#{float_to_binary(remaining_centiseconds)}"

      false ->
        "#{minutes}:#{float_to_binary(remaining_centiseconds)}"
    end
  end

  defp to_minutes_and_seconds(centiseconds) do
    minutes =
      centiseconds
      |> div(100)
      |> div(60)

    {minutes, centiseconds - minutes * 60 * 100}
  end

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

  defp float_to_binary(centiseconds), do: :erlang.float_to_binary(centiseconds / 100, decimals: 2)
end
