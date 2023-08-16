defmodule TodoList.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string

    belongs_to(:list, TodoList.Lists.List, foreign_key: :list_id, references: :id, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :completed, :list_id])
    |> validate_required([:content, :completed, :list_id])
    |> foreign_key_constraint(:list_id)
  end
end
