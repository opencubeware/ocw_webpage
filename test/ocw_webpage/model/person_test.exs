defmodule OcwWebpage.Model.PersonTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Model.{Country, Person}

  describe "new/3" do
    test "returns Person.t()" do
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      continent = %{name: continent_name}
      country = %{continent: continent, name: country_name, iso2: country_iso2}
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"

      assert %Person{
               first_name: ^first_name,
               last_name: ^last_name,
               wca_id: ^wca_id,
               country: %Country{
                 continent_name: ^continent_name,
                 name: ^country_name,
                 iso2: ^country_iso2
               }
             } =
               Person.new(%{
                 first_name: first_name,
                 last_name: last_name,
                 wca_id: wca_id,
                 country: country
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

      struct = %Person{
        first_name: first_name,
        last_name: last_name,
        wca_id: wca_id,
        country: %Country{
          continent_name: continent_name,
          name: country_name,
          iso2: country_iso2
        }
      }

      assert %{
               first_name: ^first_name,
               last_name: ^last_name,
               wca_id: ^wca_id,
               country: %{
                 continent_name: ^continent_name,
                 name: ^country_name,
                 iso2: ^country_iso2
               }
             } = Person.to_map(struct)
    end
  end
end
