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
      attempts = [730, 700, 840, 690, 700]
      average = 720
      continent = %{name: continent_name}
      country = %{continent: continent, name: country_name, iso2: country_iso2}
      person = %{country: country, first_name: first_name, last_name: last_name, wca_id: wca_id}
      results = [%{id: 1, attempts: attempts, average: average, person: person}]
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
               results: [
                 %Result{
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
                 }
               ]
             } =
               Round.new(%{
                 id: id,
                 event: event,
                 round_name: round_name,
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
      average = 720
      best_solve = Enum.min(attempts)
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
        results: [
          %Result{
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
        ]
      }

      assert %{
               id: ^id,
               name: ^name,
               event_name: ^event_name,
               tournament_name: ^tournament_name,
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
