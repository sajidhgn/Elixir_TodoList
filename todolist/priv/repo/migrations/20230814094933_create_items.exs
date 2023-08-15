defmodule Todolist.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :list_id, :string
      add :content, :string
      add :completed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
