defmodule OcwWebpage.DataAccess.Schemas.Event do
  use Ecto.Schema
  alias OcwWebpage.DataAccess.Schemas.{Round, Tournament}
  alias OcwWebpage.Constants.EventName

  schema "events" do
    belongs_to(:event_name, EventName)
    belongs_to(:tournament, Tournament)
    has_many(:rounds, Round)
  end
end
