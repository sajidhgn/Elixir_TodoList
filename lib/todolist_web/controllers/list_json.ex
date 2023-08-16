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
  def show(%{list: list}) do
    %{data: data(list)}
  end

  def show(%{error: error}) do
    %{error: error}
  end

  defp data(%List{} = list) do
    %{
      id: list.id,
      title: list.title,
      archived: list.archived
    }
  end
end
