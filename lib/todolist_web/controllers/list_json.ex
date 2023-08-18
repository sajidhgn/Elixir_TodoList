defmodule TodoListWeb.ListJSON do
  alias TodoList.Lists.List

  @doc """
  Renders a list of lists.
  """
  def index(%{lists: lists}) do
    %{data: for(list <- lists, do: data(list))}
  end

  @doc """
  Renders a single list.
  """
  def show(%{list: list, message: message}) do
    %{data: data(list), message: message}
  end

  def show(%{error: error}) do
    %{error: error}
  end

  def delete(%{message: message}) do
    %{message: message}
  end

  defp data(%List{} = list) do
    %{
      id: list.id,
      title: list.title,
      archived: list.archived
    }
  end
end
