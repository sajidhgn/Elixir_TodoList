defmodule Todolist.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string
    field :list_id, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:list_id, :content, :completed])
    |> validate_required([:list_id, :content, :completed])
  end
end
