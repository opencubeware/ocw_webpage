defmodule OcwWebpage.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: false)
      add(:wca_id, :string, null: true)
      add(:country, :string, null: false)
    end
  end
end
