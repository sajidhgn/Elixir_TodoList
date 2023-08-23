defmodule TodoListWeb.ListController do
  use TodoListWeb, :controller

  use PhoenixSwagger
  alias TodoList.Lists
  alias TodoList.Lists.List

  action_fallback(TodoListWeb.FallbackController)

  def index(conn, _params) do
    lists = Lists.list_lists()
    render(conn, :index, lists: lists)
  end



  def create(conn, list_params) do
    with {:ok, %List{} = list} <- Lists.create_list(list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lists/#{list}")
      |> render(:show, list: list, message: "list created successfully")
    end
  end

  # Swagger Create Function
  swagger_path :create do
    post("/api/lists")
    summary("List creation")
    description("List creation")
    produces("application/json")
    # security([%{Bearer: []}])

    parameters do
      body(:body, Schema.ref(:CreateList), "List Params", required: true)
    end
    response(200, "Ok")
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    render(conn, :show, list: list)
  end

  @spec archived_status(any, map) :: any
  def archived_status(conn, %{ "list" => list_params}) do

    case Lists.get_by_archived(list_params["id"]) do
      nil ->
        render(conn, :show, error: "Please unarchive list")

      list ->
        with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
          render(conn, :show, list: list, message: "list status updated successfully")
        end
    end
  end

  @spec update(any, map) :: any
  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list!(id)

    with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
      render(conn, :show, list: list, message: "list updated successfully")
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)

    with {:ok, %List{}} <- Lists.delete_list(list) do
      render(conn, :delete, message: "list deleted successfully")
    end
  end

  def archived_list(conn, %{"status" => status}) do
    lists = Lists.archived_lists(status)
    render(conn, :index, lists: lists)
  end


  def swagger_definitions do
    %{
      # TotalAbouts:
      #   swagger_schema do
      #     title("Abouts Us")
      #     description("About me details")

      #     example(%{})
      #   end,
        CreateList:
        swagger_schema do
          title("List Schema")
          description("List Schema")

          properties do
              archived(:boolean, "archived", required: true)
            title(:string, "title", required: true)
          end

          example(%{
            title: "dummy title",
            archived: true,

          })
        end
    }
  end


end
