defmodule OcwWebpage.DataAccess.ResultTest do
  use OcwWebpage.DataCase
  alias OcwWebpage.{DataAccess, Model}

  describe "get/1" do
    test "return Model.Result.t() when everything is ok" do
      result = insert(:result)

      assert {:ok, %Model.Result{competitor: %{country: %{continent_name: _name}}}} =
               DataAccess.Result.get(result.id)
    end
  end

  describe "fetch_filtered_by_name/4" do
    setup do
      %{
        tournament_name: "Cracow Open 2013",
        round_name: "First Round",
        event_name: "3x3x3",
        query: "ziel"
      }
    end

    test "return list of Model.Result.t() filtered by query", params do
      insert(:result)

      assert [%Model.Result{competitor: %{last_name: "Zielinski"}}] =
               DataAccess.Result.fetch_filtered_by_name(
                 params.tournament_name,
                 params.event_name,
                 params.round_name,
                 params.query
               )
    end

    test "return empty list of when nothing is found", params do
      assert [] =
               DataAccess.Result.fetch_filtered_by_name(
                 params.tournament_name,
                 params.event_name,
                 params.round_name,
                 params.query
               )
    end
  end

  describe "update/1" do
    setup do
      continent_name = "Europe"
      country_name = "Poland"
      country_iso2 = "pl"
      first_name = "John"
      last_name = "Doe"
      wca_id = "2009wcaid"
      attempts = [730, 700, 840, 690, 700]
      result = insert(:result)

      %{
        struct: %Model.Result{
          id: result.id,
          attempts: attempts,
          average: nil,
          competitor: %Model.Person{
            first_name: first_name,
            last_name: last_name,
            wca_id: wca_id,
            country: %Model.Country{
              continent_name: continent_name,
              name: country_name,
              iso2: country_iso2
            }
          }
        }
      }
    end

    test "saves model to db", %{struct: struct} do
      assert {:ok, %DataAccess.Schemas.Result{}} = DataAccess.Result.update_times_in_db(struct)
    end
  end

  describe "validate_and_transform_params/1" do
    setup do
      %{
        params: %{
          first: "790",
          second: "490",
          third: "320",
          fourth: "590",
          fifth: "540",
          id: "1"
        }
      }
    end

    test "returns error when any of the attempts is not integer", %{params: params} do
      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | first: "test"})

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | second: "test"})

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | third: "test"})

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | fourth: "test"})

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | fifth: "test"})
    end

    test "returns FE.Result.t() when everything is ok", %{params: params} do
      assert {:ok, %{attempts: [790, 490, 320, 590, 540], id: "1"}} ==
               DataAccess.Result.validate_and_transform_params(params)
    end

    test "returns FE.Result.t() with :no_change when field is missing", %{params: params} do
      assert {:ok, %{attempts: [790, :no_change, 320, 590, 540], id: "1"}} ==
               DataAccess.Result.validate_and_transform_params(%{params | second: ""})

      assert {:ok, %{attempts: [:no_change, :no_change, 320, 590, 540], id: "1"}} ==
               DataAccess.Result.validate_and_transform_params(%{params | first: "", second: ""})

      assert {:ok, %{attempts: [:no_change, :no_change, :no_change, 590, 540], id: "1"}} ==
               DataAccess.Result.validate_and_transform_params(%{
                 params
                 | first: "",
                   second: "",
                   third: ""
               })

      assert {:ok, %{attempts: [:no_change, :no_change, :no_change, :no_change, 540], id: "1"}} ==
               DataAccess.Result.validate_and_transform_params(%{
                 params
                 | first: "",
                   second: "",
                   third: "",
                   fourth: ""
               })

      assert {:ok,
              %{attempts: [:no_change, :no_change, :no_change, :no_change, :no_change], id: "1"}} ==
               DataAccess.Result.validate_and_transform_params(%{
                 params
                 | first: "",
                   second: "",
                   third: "",
                   fourth: "",
                   fifth: ""
               })
    end
  end
end