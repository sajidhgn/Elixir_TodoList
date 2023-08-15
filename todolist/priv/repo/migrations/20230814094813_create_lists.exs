defmodule Todolist.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :archived, :boolean, default: false, null: false

      timestamps()
    end
  end
end
