defmodule TodoListWeb.ItemJSON do
  alias TodoList.Items.Item

  @doc """
  Renders a list of items.
  """
  def index(%{items: items}) do
    %{data: for(item <- items, do: data(item))}
  end

  @doc """
  Renders a single item.
  """
  def show(%{item: item, message: message}) do
    %{data: data(item), message: message}
  end

  def show(%{error: error}) do
    %{error: error}
  end

  def delete(%{message: message}) do
    %{message: message}
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
