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
end
