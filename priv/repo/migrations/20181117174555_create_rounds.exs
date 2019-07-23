defmodule OcwWebpage.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add(:round_name_id, references("round_names"), null: true)
      add(:event_id, references(:events), null: false)
    end

    create(index(:rounds, :round_name_id))
  end
end
