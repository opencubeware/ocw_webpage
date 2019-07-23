defmodule OcwWebpage.Repo.Migrations.AddCountryToPerson do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      remove(:country)
      add(:country_id, references(:countries, null: false))
    end
  end
end
