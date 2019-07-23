defmodule OcwWebpage.DataAccess.Schemas.Person do
  use Ecto.Schema

  alias OcwWebpage.DataAccess.Schemas.{Country, Result}

  schema "persons" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:wca_id, :string)
    belongs_to(:country, Country)
    has_many(:results, Result, foreign_key: :competitor_id)
  end
end
