defmodule OcwWebpage.DataAccess.Schemas.Round do
  use Ecto.Schema

  alias OcwWebpage.DataAccess.Schemas.{Event, Result}
  alias OcwWebpage.Constants.RoundName

  schema "rounds" do
    has_many(:results, Result)
    belongs_to(:round_name, RoundName)
    belongs_to(:event, Event)
  end
end
