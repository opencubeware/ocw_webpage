defmodule OcwWebpage.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      add(:name, :string, null: false)
    end

    create(index(:tournaments, :name))
  end
end
