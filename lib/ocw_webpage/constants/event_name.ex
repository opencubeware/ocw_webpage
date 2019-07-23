defmodule OcwWebpage.Constants.EventName do
  use Ecto.Schema
  alias OcwWebpage.DataAccess.Schemas.Event

  schema "event_names" do
    field(:name, :string)
    has_many(:events, Event)
  end

  def to_string("3x3x3Blindfolded"), do: "3x3x3 Blindfolded"
  def to_string("3x3x3FewestMoves"), do: "3x3x3 Fewest Moves"
  def to_string("3x3x3OneHanded"), do: "3x3x3 One-Handed"
  def to_string("3x3x3WithFeet"), do: "3x3x3 With Feet"
  def to_string("4x4x4Blindfolded"), do: "4x4x4 Blindfolded"
  def to_string("5x5x5Blindfolded"), do: "5x5x5 Blindfolded"
  def to_string("3x3x3MultiBlind"), do: "3x3x3 Multi-Blind"
  def to_string(single_word_name), do: single_word_name
end
