defmodule OcwWebpage.Constants.RoundName do
  use Ecto.Schema
  alias OcwWebpage.DataAccess.Schemas.Round

  schema "round_names" do
    field(:name, :string)
    has_many(:rounds, Round)
  end

  def to_string("FirstRound"), do: "First Round"
  def to_string("SecondRound"), do: "Second Round"
  def to_string("FinalRound"), do: "Final Round"
  def to_string("CombinedFirst"), do: "Combined First"
  def to_string("CombinedFinal"), do: "Combined Final"
end
