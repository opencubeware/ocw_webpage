defmodule OcwWebpage.Repo.Migrations.AddCountriesAndContinents do
  use Ecto.Migration

  def change do
    create table(:continents) do
      add(:name, :string, null: false)
    end

    create table(:countries) do
      add(:name, :string, null: false)
      add(:iso2, :string, null: false)
      add(:continent_id, references(:continents), null: false)
    end

    alter table(:tournaments) do
      add(:country_id, references(:countries, null: false))
    end
  end
end
