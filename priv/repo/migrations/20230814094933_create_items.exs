defmodule TodoList.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content, :string
      add :completed, :boolean, default: false, null: false
      add :list_id, references(:lists, type: :uuid, column: :uuid)

      timestamps()
    end

    create unique_index(:items, [:list_id])
  end
end
