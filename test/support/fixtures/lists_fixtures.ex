defmodule Todolist.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        archived: true,
        title: "some title"
      })
      |> Todolist.Lists.create_list()

    list
  end
end
