defmodule OcwWebpage.Repo.Migrations.AddCutoffToRounds do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add(:cutoff, :integer, null: true)
    end
  end
end
