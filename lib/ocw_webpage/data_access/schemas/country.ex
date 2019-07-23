defmodule OcwWebpage.DataAccess.Schemas.Country do
  use Ecto.Schema

  alias OcwWebpage.DataAccess.Schemas.{Continent, Person}

  schema "countries" do
    field(:name, :string)
    field(:iso2, :string)
    belongs_to(:continent, Continent)
    has_many(:persons, Person)
  end
end
