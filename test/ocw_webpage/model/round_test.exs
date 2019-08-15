defmodule OcwWebpage.Model.RoundTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Model.{Round, Person, Country, Result}

  describe "new/3" do
    test "returns Round.t()" do
      id = 5
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [2920, 2800, 3360, 2760, 2800]
      maybe_attempts = [{:just, 730}, {:just, 700}, {:just, 840}, {:just, 690}, {:just, 700}]
      average = 720
      shifted_average = 2880
      best_solve = 690
      cutoff = 300
      format = "ao5"
      continent = %{name: continent_name}
      country = %{continent: continent, name: country_name, iso2: country_iso2}
      person = %{country: country, first_name: first_name, last_name: last_name, wca_id: wca_id}
      results = [%{id: 1, attempts: attempts, average: shifted_average, person: person}]
      tournament_name = "Cracow Open 2013"
      event_name = "3x3x3"
      name = "First Round"
      round_name = %{name: name}
      event = %{event_name: %{name: event_name}, tournament: %{name: tournament_name}}

      assert %Round{
               id: ^id,
               event_name: ^event_name,
               name: ^name,
               tournament_name: ^tournament_name,
               cutoff: {:just, ^cutoff},
               format: ^format,
               results: [
                 %Result{
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
                 }
               ]
             } =
               Round.new(%{
                 id: id,
                 event: event,
                 round_name: round_name,
                 cutoff: cutoff,
                 format: format,
                 results: results
               })
    end
  end

  describe "to_map/1" do
    test "returns propper map from struct" do
      id = 5
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [730, 700, 840, 690, 700]
      average = {:just, 720}
      best_solve = {:just, 690}
      cutoff = :nothing
      format = "ao5"
      format_translated = "Average of 5"
      attempts_translated = Enum.map(attempts, &Result.format_time(&1))
      average_translated = Result.format_time(average)
      best_solve_translated = Result.format_time(best_solve)
      tournament_name = "Cracow Open 2013"
      event_name = "3x3x3"
      name = "First Round"

      struct = %Round{
        id: id,
        event_name: event_name,
        name: name,
        tournament_name: tournament_name,
        cutoff: cutoff,
        format: format,
        results: [
          %Result{
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
        ]
      }

      assert %{
               id: ^id,
               name: ^name,
               event_name: ^event_name,
               tournament_name: ^tournament_name,
               cutoff: "",
               format: ^format_translated,
               results: [
                 %{
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
                 }
               ]
             } = Round.to_map(struct)
    end
  end
end
