defmodule TodolistWeb.ItemJSON do
  alias Todolist.Items.Item

  @doc """
  Renders a list of items.
  """
  def index(%{items: items}) do
    %{data: for(item <- items, do: data(item))}
  end

  @doc """
  Renders a single item.
  """
  def show(%{item: item}) do
    %{data: data(item)}
  end

  defp data(%Item{} = item) do
    %{
      id: item.id,
      list_id: item.list_id,
      content: item.content,
      completed: item.completed
    }
  end
end
