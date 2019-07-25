defmodule OcwWebpage.Constants.RoundNameTest do
  alias OcwWebpage.Constants.RoundName
  use OcwWebpage.DataCase

  describe "to_string/1" do
    test "to_string returns correct values" do
      assert RoundName.to_string("FirstRound") == "First Round"
      assert RoundName.to_string("SecondRound") == "Second Round"
      assert RoundName.to_string("FinalRound") == "Final Round"
      assert RoundName.to_string("CombinedFirst") == "Combined First"
      assert RoundName.to_string("CombinedFinal") == "Combined Final"
    end
  end
end
