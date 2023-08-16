defmodule TodoList.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoList.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        completed: true,
        content: "some content",
        list_id: "some list_id"
      })
      |> TodoList.Items.create_item()

    item
  end
end
