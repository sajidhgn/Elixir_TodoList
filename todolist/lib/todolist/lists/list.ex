defmodule Todolist.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :archived, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :archived])
    |> validate_required([:title, :archived])
  end
end
