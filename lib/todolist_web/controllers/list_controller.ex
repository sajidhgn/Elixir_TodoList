defmodule TodoListWeb.ListController do
  use TodoListWeb, :controller

  alias TodoList.Lists
  alias TodoList.Lists.List

  action_fallback(TodoListWeb.FallbackController)

  def index(conn, _params) do
    lists = Lists.list_lists()
    render(conn, :index, lists: lists)
  end

  def create(conn, %{"list" => list_params}) do
    with {:ok, %List{} = list} <- Lists.create_list(list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lists/#{list}")
      |> render(:show, list: list)
    end
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    render(conn, :show, list: list)
  end

  @spec archived_status(any, map) :: any
  def archived_status(conn, %{ "list" => list_params}) do

    case Lists.get_by_archived(list_params["id"]) do
      nil ->
        render(conn, :show, error: "hi i am error")

      list ->
        with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
          render(conn, :show, list: list)
        end
    end
  end

  @spec update(any, map) :: any
  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list!(id)

    with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
      render(conn, :show, list: list)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)

    with {:ok, %List{}} <- Lists.delete_list(list) do
      send_resp(conn, :no_content, "")
    end
  end

  def archived_list(conn, %{"status" => status}) do
    lists = Lists.archived_lists(status)
    render(conn, :index, lists: lists)
  end
end
