defmodule OcwWebpage.Model.Person do
  defstruct [:first_name, :last_name, :wca_id, :country]

  alias OcwWebpage.Model

  @type t :: %__MODULE__{
          country: Model.Country.t(),
          first_name: String.t(),
          last_name: String.t(),
          wca_id: String.t()
        }

  @spec new(%{
          country: map(),
          first_name: String.t(),
          last_name: String.t(),
          wca_id: String.t()
        }) :: t()
  def new(%{
        first_name: first_name,
        last_name: last_name,
        wca_id: wca_id,
        country: country
      }) do
    struct(__MODULE__, %{
      first_name: first_name,
      last_name: last_name,
      wca_id: wca_id,
      country: Model.Country.new(country)
    })
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = struct), do: Map.from_struct(struct)
end
