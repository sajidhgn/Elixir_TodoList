defmodule TodoList.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "lists" do
    field :archived, :boolean, default: false
    field :title, :string
    has_many :items, TodoList.Items.Item

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :archived])
    |> validate_required([:title, :archived])
  end
end
