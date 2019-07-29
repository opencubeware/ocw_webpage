defmodule OcwWebpage.Model.ResultTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Model.{Person, Country, Result}

  describe "new/3" do
    test "returns Result.t()" do
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [730, 700, 840, 690, 700]
      average = 720
      continent = %{name: continent_name}
      country = %{continent: continent, name: country_name, iso2: country_iso2}
      person = %{country: country, first_name: first_name, last_name: last_name, wca_id: wca_id}

      assert %Result{
               attempts: ^attempts,
               average: ^average,
               competitor: %Person{
                 first_name: ^first_name,
                 last_name: ^last_name,
                 wca_id: ^wca_id,
                 country: %Country{
                   continent_name: ^continent_name,
                   name: ^country_name,
                   iso2: ^country_iso2
                 }
               }
             } =
               Result.new(%{
                 attempts: attempts,
                 average: average,
                 person: person
               })
    end
  end

  describe "to_map/1" do
    test "returns propper map from struct" do
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [730, 700, 840, 690, 700]
      average = 720
      best_solve = Enum.min(attempts)
      attempts_translated = Enum.map(attempts, &Result.format_time(&1))
      average_translated = Result.format_time(average)
      best_solve_translated = Result.format_time(best_solve)

      struct = %Result{
        attempts: attempts,
        average: average,
        competitor: %Person{
          first_name: first_name,
          last_name: last_name,
          wca_id: wca_id,
          country: %Country{
            continent_name: continent_name,
            name: country_name,
            iso2: country_iso2
          }
        }
      }

      assert %{
               attempts: ^attempts_translated,
               average: ^average_translated,
               best_solve: ^best_solve_translated,
               competitor: %{
                 first_name: ^first_name,
                 last_name: ^last_name,
                 wca_id: ^wca_id,
                 country: %{
                   continent_name: ^continent_name,
                   name: ^country_name,
                   iso2: ^country_iso2
                 }
               }
             } = Result.to_map(struct)
    end
  end

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
