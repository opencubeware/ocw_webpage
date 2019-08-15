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
      attempts = [{:just, 730}, {:just, 700}, {:just, 840}, {:just, 690}, {:just, 700}]
      result = insert(:result)

      %{
        struct: %Model.Result{
          id: result.id,
          attempts: attempts,
          average: :nothing,
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
          "result" => %{
            "first" => "790",
            "second" => "490",
            "third" => "320",
            "fourth" => "590",
            "fifth" => "540",
            "format" => "Average of 5",
            "id" => "1"
          }
        }
      }
    end

    test "returns error when any of the attempts is not integer", %{params: params} do
      new_time =
        params
        |> Map.get("result")
        |> Map.put("first", "test")

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.put("second", "test")

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.put("third", "test")

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.put("fourth", "test")

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.put("fifth", "test")

      assert {:error, :param_not_integer} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})
    end

    test "returns FE.Result.t() when everything is ok", %{params: params} do
      assert {:ok,
              %{
                attempts: [{:just, 790}, {:just, 490}, {:just, 320}, {:just, 590}, {:just, 540}],
                id: "1",
                format: :ao5
              }} ==
               DataAccess.Result.validate_and_transform_params(params)
    end

    test "returns FE.Result.t() with :no_change when field is missing", %{params: params} do
      new_time =
        params
        |> Map.get("result")
        |> Map.merge(%{"format" => "Average of 5", "second" => ""})

      assert {:ok,
              %{
                attempts: [{:just, 790}, :nothing, {:just, 320}, {:just, 590}, {:just, 540}],
                id: "1",
                format: :ao5
              }} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.merge(%{"format" => "Average of 5", "first" => "", "second" => ""})

      assert {:ok,
              %{
                attempts: [:nothing, :nothing, {:just, 320}, {:just, 590}, {:just, 540}],
                id: "1",
                format: :ao5
              }} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.merge(%{"format" => "Average of 5", "first" => "", "second" => "", "third" => ""})

      assert {:ok,
              %{
                attempts: [:nothing, :nothing, :nothing, {:just, 590}, {:just, 540}],
                id: "1",
                format: :ao5
              }} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.merge(%{
          "format" => "Average of 5",
          "first" => "",
          "second" => "",
          "third" => "",
          "fourth" => ""
        })

      assert {:ok,
              %{
                attempts: [:nothing, :nothing, :nothing, :nothing, {:just, 540}],
                id: "1",
                format: :ao5
              }} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})

      new_time =
        params
        |> Map.get("result")
        |> Map.merge(%{
          "first" => "",
          "second" => "",
          "third" => "",
          "fourth" => "",
          "format" => "Average of 5",
          "fifth" => ""
        })

      assert {:ok,
              %{
                attempts: [:nothing, :nothing, :nothing, :nothing, :nothing],
                id: "1",
                format: :ao5
              }} ==
               DataAccess.Result.validate_and_transform_params(%{params | "result" => new_time})
    end
  end

  describe "assign_index/1" do
    test "returns correct number when called" do
      attempts_1 = [590, 470, 390, 430, 490]
      attempts_2 = [690, 570, 490, 530, 590]
      average_1 = 390
      average_2 = 490
      round = insert(:round)
      insert(:result, attempts: attempts_1, average: average_1, round: round)
      insert(:result, attempts: attempts_2, average: average_2, round: round)
      result_1 = Repo.get_by(DataAccess.Schemas.Result, average: average_1)
      result_2 = Repo.get_by(DataAccess.Schemas.Result, average: average_2)

      assert 0 == DataAccess.Result.assign_index(result_1)
      assert 1 == DataAccess.Result.assign_index(result_2)
    end
  end
end
