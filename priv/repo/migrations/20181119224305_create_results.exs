defmodule OcwWebpage.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add(:round_id, references(:rounds), null: false)
      add(:attempts, {:array, :integer})
      add(:competitor_id, references(:persons), null: false)
    end
  end
end
