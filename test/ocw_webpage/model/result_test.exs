defmodule OcwWebpage.Model.ResultTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Model.Result

  describe "format_time/1" do
    test "returns correct values" do
      assert "00:00.12" == Result.format_time(12)
      assert "00:00.99" == Result.format_time(99)
      assert "00:03.00" == Result.format_time(300)
      assert "00:05.01" == Result.format_time(501)
      assert "00:05.41" == Result.format_time(541)
      assert "00:09.99" == Result.format_time(999)
      assert "00:10.00" == Result.format_time(1000)
      assert "00:12.00" == Result.format_time(1200)
      assert "00:12.01" == Result.format_time(1201)
      assert "00:12.41" == Result.format_time(1241)
      assert "00:42.41" == Result.format_time(4241)
      assert "00:59.99" == Result.format_time(5999)
      assert "01:00.00" == Result.format_time(6000)
      assert "02:00.00" == Result.format_time(12000)
      assert "10:00.00" == Result.format_time(60000)
      assert "12:03.41" == Result.format_time(72341)
      assert "60:00.01" == Result.format_time(360_001)
    end
  end
end
