defmodule TodoListWeb.ItemController do
  use TodoListWeb, :controller

  import Ecto

  alias TodoList.Repo

  alias TodoList.Items
  alias TodoList.Items.Item

  action_fallback(TodoListWeb.FallbackController)

  def index(conn, _params) do
    items = Items.list_items()

    render(conn, :index, items: items)
  end

  def create(conn, %{"item" => item_params}) do
    IO.inspect(item_params)

    with {:ok, %Item{} = item} <- Items.create_item(item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/items/#{item}")
      |> render(:show, item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Items.get_item!(id)
    render(conn, :show, item: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do

    item = Items.get_item!(id)
    data = Repo.preload(item, [:list])

    case list_archived?(data) do
      true ->
        render(conn, :show, error: "please archived make false")

      false ->
        with {:ok, %Item{} = item} <- Items.update_item(item, item_params) do
          render(conn, :show, item: item)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Items.get_item!(id)

    with {:ok, %Item{}} <- Items.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end

  defp list_archived?(%{list: %{archived: true}}), do: true
  defp list_archived?(_), do: false
end
