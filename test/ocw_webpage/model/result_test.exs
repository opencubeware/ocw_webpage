defmodule OcwWebpage.Model.ResultTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Model.{Person, Country, Result}

  describe "new/3" do
    test "returns Result.t()" do
      id = 5
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [730, 700, 840, 690, 700]
      maybe_attempts = [{:just, 730}, {:just, 700}, {:just, 840}, {:just, 690}, {:just, 700}]
      best_solve = 690
      average = 720
      continent = %{name: continent_name}
      country = %{continent: continent, name: country_name, iso2: country_iso2}
      person = %{country: country, first_name: first_name, last_name: last_name, wca_id: wca_id}

      assert %Result{
               id: ^id,
               attempts: ^maybe_attempts,
               average: {:just, ^average},
               best_solve: {:just, ^best_solve},
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
                 id: id,
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
      average = {:just, 720}
      best_solve = {:just, 690}
      attempts_translated = ["00:07.30", "00:07.00", "00:08.40", "00:06.90", "00:07.00"]
      average_translated = "00:07.20"
      best_solve_translated = "00:06.90"

      struct = %Result{
        attempts: attempts,
        average: average,
        best_solve: best_solve,
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

  describe "calculate_average/1" do
    setup do
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [730, 700, 840, 690, 700]

      %{
        struct: %Result{
          attempts: attempts,
          average: nil,
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
      }
    end

    test "return nil when there is less than 3 attempts", %{struct: struct} do
      attempts_1 = [590]
      struct = %Result{struct | attempts: attempts_1}
      assert %Result{average: nil} = Result.calculate_average(struct, :ao5)

      attempts_2 = [590, 690]
      struct = %Result{struct | attempts: attempts_2}
      assert %Result{average: nil} = Result.calculate_average(struct, :ao5)
    end

    test "calculates average when there is more than 3 attempts", %{struct: struct} do
      attempts = [380, 390, 400]
      struct = %Result{struct | attempts: attempts}

      assert %Result{average: 390} = Result.calculate_average(struct, :ao5)
    end

    test "removes best and worst time when there is more than 3 attempts", %{struct: struct} do
      attempts_1 = [530, 590, 680, 590]
      struct = %Result{struct | attempts: attempts_1}
      assert %Result{average: 590} = Result.calculate_average(struct, :ao5)

      attempts_2 = [530, 590, 600, 580, 680]
      struct = %Result{struct | attempts: attempts_2}
      assert %Result{average: 590} = Result.calculate_average(struct, :ao5)
    end
  end

  describe "update_attempts/2" do
    setup do
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [{:just, 730}, {:just, 700}, {:just, 840}, {:just, 690}, {:just, 700}]

      %{
        struct: %Result{
          attempts: attempts,
          average: nil,
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
      }
    end

    test "returns error if attempts is not an array", %{struct: struct} do
      attempts = "not an array"
      assert {:error, :not_an_array} == Result.update_attempts(struct, attempts)
    end

    test "returns correct Model.Result.t() with updated attempts", %{struct: struct} do
      attempts = [{:just, 490}, {:just, 590}, {:just, 690}, {:just, 790}, {:just, 890}]

      assert %Result{attempts: ^attempts} = Result.update_attempts(struct, attempts)
    end

    test "updates only fields with no :no_change", %{struct: struct} do
      attempts = [{:just, 490}, :nothing, {:just, 690}, :nothing, {:just, 890}]

      assert %Result{
               attempts: [{:just, 490}, {:just, 700}, {:just, 690}, {:just, 690}, {:just, 890}]
             } = Result.update_attempts(struct, attempts)
    end
  end
end
