defmodule OcwWebpage.Constants.EventNameTest do
  alias OcwWebpage.Constants.EventName
  use OcwWebpage.DataCase

  describe "to_string/1" do
    test "to_string returns correct values" do
      assert EventName.to_string("3x3x3Blindfolded") == "3x3x3 Blindfolded"
      assert EventName.to_string("3x3x3FewestMoves") == "3x3x3 Fewest Moves"
      assert EventName.to_string("3x3x3OneHanded") == "3x3x3 One-Handed"
      assert EventName.to_string("3x3x3WithFeet") == "3x3x3 With Feet"
      assert EventName.to_string("4x4x4Blindfolded") == "4x4x4 Blindfolded"
      assert EventName.to_string("5x5x5Blindfolded") == "5x5x5 Blindfolded"
      assert EventName.to_string("3x3x3MultiBlind") == "3x3x3 Multi-Blind"
      assert EventName.to_string("test") == "test"
      assert EventName.to_string("3x3x3") == "3x3x3"
    end
  end
end
