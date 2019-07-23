defmodule OcwWebpage.DataAccess.Schemas.Continent do
  use Ecto.Schema

  schema "continents" do
    field(:name, :string)
  end
end
