defmodule OcwWebpage.Factory do
  use ExMachina.Ecto, repo: OcwWebpage.Repo
  alias OcwWebpage.DataAccess.Schemas

  def result_factory() do
    %Schemas.Result{
      attempts: [2360, 1560, 1960, 3600, 2760],
      average: 2360,
      round: build(:round),
      person: build(:person)
    }
  end

  def person_factory() do
    %Schemas.Person{
      first_name: "Kamil",
      last_name: "Zielinski",
      wca_id: "2009Zieli",
      country_id: 143
    }
  end

  def round_factory() do
    %Schemas.Round{
      round_name_id: 1,
      event: build(:event),
      cutoff: nil,
      format: "ao5"
    }
  end

  def event_factory() do
    %Schemas.Event{
      event_name_id: 1,
      tournament: build(:tournament)
    }
  end

  def tournament_factory() do
    %Schemas.Tournament{
      name: "Cracow Open 2013",
      country_id: 3
    }
  end
end
