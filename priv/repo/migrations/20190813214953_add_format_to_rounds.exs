defmodule OcwWebpage.Repo.Migrations.AddFormatToRounds do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add(:format, :string, null: false, default: "mo5")
    end
  end
end
