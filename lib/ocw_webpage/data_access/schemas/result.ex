defmodule OcwWebpage.DataAccess.Schemas.Result do
  use Ecto.Schema
  import Ecto.Changeset

  alias OcwWebpage.DataAccess.Schemas.{Person, Round}

  schema "results" do
    field(:attempts, {:array, :integer})
    field(:average, :integer)
    belongs_to(:round, Round)
    belongs_to(:person, Person, foreign_key: :competitor_id)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:attempts, :average])
  end
end
