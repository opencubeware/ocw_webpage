defmodule OcwWebpage.DataAccess.Schemas.Wca.RanksSingle do
  use Ecto.Schema
  alias OcwWebpage.DataAccess.Schemas.Wca.Person
  @primary_key false

  schema "RanksSingle" do
    field(:eventId, :string)
    field(:best, :integer)
    field(:worldRank, :integer)
    field(:continentRank, :integer)
    field(:countryRank, :integer)
    belongs_to(:person, Person, foreign_key: :personId, references: :id, type: :string)
  end
end
