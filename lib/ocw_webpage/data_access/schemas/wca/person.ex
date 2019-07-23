defmodule OcwWebpage.DataAccess.Schemas.Wca.Person do
  use Ecto.Schema
  alias OcwWebpage.DataAccess.Schemas.Wca.RanksSingle
  @primary_key false

  schema "Persons" do
    field(:id, :string)
    field(:subid, :integer)
    field(:name, :string)
    field(:countryId, :string)
    field(:gender, :string)
    has_many(:ranks_single, RanksSingle, foreign_key: :personId, references: :id)
  end
end
