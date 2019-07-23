defmodule OcwWebpage.Repo.Migrations.CreateRoundNames do
  use Ecto.Migration

  def change do
    create table(:round_names) do
      add(:name, :string, null: false)
    end
  end
end
