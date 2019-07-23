defmodule OcwWebpage.Repo.Migrations.CreateEventNames do
  use Ecto.Migration

  def change do
    create table(:event_names) do
      add(:name, :string, null: false)
    end
  end
end
