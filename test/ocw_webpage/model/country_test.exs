defmodule OcwWebpage.Model.CountryTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.Model.Country

  describe "new/3" do
    test "returns Country.t()" do
      continent_name = "Europe"
      continent = %{name: continent_name}
      name = "Poland"
      iso2 = "pl"

      assert %Country{name: ^name, continent_name: ^continent_name, iso2: ^iso2} =
               Country.new(%{continent: continent, name: name, iso2: iso2})
    end
  end

  describe "to_map/1" do
    test "returns propper map from struct" do
      continent_name = "Europe"
      name = "Poland"
      iso2 = "pl"
      struct = %Country{name: name, continent_name: continent_name, iso2: iso2}

      assert %{
               name: ^name,
               continent_name: ^continent_name,
               iso2: ^iso2
             } = Country.to_map(struct)
    end
  end
end
