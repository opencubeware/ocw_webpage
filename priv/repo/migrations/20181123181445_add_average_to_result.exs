defmodule OcwWebpage.Repo.Migrations.AddAverageToResult do
  use Ecto.Migration

  def up do
    alter table(:results) do
      add(:average, :integer, null: true)
    end
  end

  def down do
    alter table(:results) do
      remove(:average)
    end
  end
end
