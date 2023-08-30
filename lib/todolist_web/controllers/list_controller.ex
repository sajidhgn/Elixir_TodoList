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

   # Swagger List Function
   swagger_path :index do
    get("/api/lists")
    summary("Get total lists")
    description("Get total lists")
    produces("application/json")
    # security([%{Bearer: []}])
    response(200, "Ok", Schema.ref(:TotalLists))
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
    render(conn, :show, list: list, message: "get list successfully")
  end

  # Swagger Edit with ID
    swagger_path :show do
      get("/api/lists/{id}")
      summary("Get single list")
      description("Get single list")
      produces("application/json")
      # security([%{Bearer: []}])
      parameters do
        id :path, :string, "List Id", required: true
      end
      response(200, "Ok", Schema.ref(:SingleList))
    end




  @spec archived_status(any, map) :: any
  def archived_status(conn, list_params) do

    case Lists.get_by_archived(list_params["id"]) do
      nil ->
        render(conn, :show, error: "Please unarchive list")

      list ->
        with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
          render(conn, :show, list: list, message: "list status updated successfully")
        end
    end
  end

  # Swagger update archive status
  swagger_path :archived_status do
    put("/api/archived-status")
    summary("Update list status")
    description("Update list status")
    produces("application/json")
    # security([%{Bearer: []}])
    parameters do
      body(:body, Schema.ref(:StatusUpdateList), "List Params", required: true)
    end
    response(200, "Ok")
  end

  @spec update(any, map) :: any
  def update(conn, list_params) do
    list = Lists.get_list!(list_params["id"])

    with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
      render(conn, :show, list: list, message: "list updated successfully")
    end
  end

  # Swagger update list
  swagger_path :update do
    put("/api/lists/{id}")
    summary("Update list ")
    description("Update list")
    produces("application/json")
    # security([%{Bearer: []}])
    parameters do
      id :path, :string, "List Id", required: true
      body(:body, Schema.ref(:UpdateList), "List Params", required: true)
    end
    response(200, "Ok")
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)

    with {:ok, %List{}} <- Lists.delete_list(list) do
      render(conn, :delete, message: "list deleted successfully")
    end
  end

   # Swagger Edit with ID
   swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/lists/{id}")
    summary("Get single list")
    description("Get single list")
    produces("application/json")
    # security([%{Bearer: []}])
    parameters do
      id :path, :string, "List Id", required: true
    end
    response(200, "Ok", Schema.ref(:DeleteList))
  end

  def archived_list(conn, %{"status" => status}) do
    lists = Lists.archived_lists(status)
    render(conn, :index, lists: lists)
  end


  def swagger_definitions do
    %{
      TotalLists:
      swagger_schema do
        title("Lists")
        description("List details")

        example(%{})
      end,
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
        end,
        SingleList:
      swagger_schema do
        title("Single List")
        description("List details")

        example(%{})
      end,
      StatusUpdateList:
      swagger_schema do
        title("Status update List")
        description("Status update list details")

        properties do
          id(:string, "id", required: true)
        title(:string, "title", required: true)
        archived(:boolean, "archived", required: false)
      end

        example(%{
          archived: true,
                title: "najams",
                id: "4c27de4f-ea2b-44bc-a871-b6f477b7417d"
        })
      end,
      UpdateList:
      swagger_schema do
        title("update List")
        description("update list details")

        properties do
          id(:string, "id", required: true)
        title(:string, "title", required: true)
        archived(:boolean, "archived", required: true)
      end
        example(%{
                archived: true,
                title: "james",
                id: "4c27de4f-ea2b-44bc-a871-b6f477b7417d"

        })
      end,
      DeleteList:
      swagger_schema do
        title("Delete List")
        description("Delete list details")

        properties do
          id(:string, "id", required: true)
      end

        example(%{})
      end,
    }
  end


end
