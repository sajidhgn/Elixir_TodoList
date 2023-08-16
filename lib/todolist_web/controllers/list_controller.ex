defmodule TodolistWeb.ListController do
  use TodolistWeb, :controller

  alias Todolist.Lists
  alias Todolist.Lists.List

  action_fallback TodolistWeb.FallbackController

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
