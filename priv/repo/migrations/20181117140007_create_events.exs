defmodule OcwWebpage.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:event_name_id, references("event_names"), null: false)
      add(:tournament_id, references(:tournaments), null: false)
    end

    create(index(:events, :event_name_id))
  end
end
