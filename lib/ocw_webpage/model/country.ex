defmodule OcwWebpage.Model.Country do
  defstruct([:continent_name, :iso2, :name])

  @type t :: %__MODULE__{
          continent_name: String.t(),
          name: String.t(),
          iso2: String.t()
        }

  @spec new(%{continent: map(), name: String.t(), iso2: String.t()}) :: t()
  def new(%{continent: continent, iso2: iso2, name: name}) do
    struct(__MODULE__, %{name: name, continent_name: continent.name, iso2: iso2})
  end

  @spec to_map(t()) :: map()
  def to_map(struct), do: Map.from_struct(struct)
end
