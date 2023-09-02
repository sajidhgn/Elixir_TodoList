defmodule TodoListWeb.ItemController do
  use TodoListWeb, :controller

  use PhoenixSwagger
  alias TodoList.Repo
  alias TodoList.Items
  alias TodoList.Items.Item

  action_fallback(TodoListWeb.FallbackController)

  def index(conn, _params) do
    items = Items.list_items()

    render(conn, :index, items: items)
  end

   # Swagger List Function
   swagger_path :index do
    get("/api/items")
    summary("Get total items")
    description("Get total items")
    produces("application/json")
    # security([%{Bearer: []}])
    response(200, "Ok", Schema.ref(:TotalItems))
  end

  def create(conn, item_params) do

    with {:ok, %Item{} = item} <- Items.create_item(item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/items/#{item}")
      |> render(:show, item: item, message: "Item created successfully")
    end
  end

  # Swagger Create Function
  swagger_path :create do
    post("/api/items")
    summary("items creation")
    description("items creation")
    produces("application/json")
    # security([%{Bearer: []}])

    parameters do
      body(:body, Schema.ref(:CreateItem), "items Params", required: true)
    end
    response(200, "Ok")
  end

  def show(conn, %{"id" => id}) do
    item = Items.get_item!(id)
    render(conn, :show, item: item)
  end

  # Swagger Edit with ID
  swagger_path :show do
    get("/api/items/{id}")
    summary("Get single item")
    description("Get single litemist")
    produces("application/json")
    # security([%{Bearer: []}])
    parameters do
      id :path, :string, "Item Id", required: true
    end
    response(200, "Ok", Schema.ref(:SingleItem))
  end

  def update(conn, %{"id" => id, "item" => item_params}) do

    item = Items.get_item!(id)
    data = Repo.preload(item, [:list])

    case list_archived?(data) do
      true ->
        render(conn, :show, error: "please unarchive list")

      false ->
        with {:ok, %Item{} = item} <- Items.update_item(item, item_params) do
          render(conn, :show, item: item, message: "Item updated successfully")
        end
    end
  end
  # Swagger update list
  swagger_path :update do
    put("/api/items/{id}")
    summary("Update item ")
    description("Update item")
    produces("application/json")
    # security([%{Bearer: []}])
    parameters do
      id :path, :string, "Item Id", required: true
      body(:body, Schema.ref(:UpdateItem), "Item Params", required: true)
    end
    response(200, "Ok")
  end

  def delete(conn, %{"id" => id}) do
    item = Items.get_item!(id)

    with {:ok, %Item{}} <- Items.delete_item(item) do
      render(conn, :delete, message: "Item deleted successfully")
    end
  end

   # Swagger Edit with ID
   swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/items/{id}")
    summary("Delete single item")
    description("Delete single item")
    produces("application/json")
    # security([%{Bearer: []}])
    parameters do
      id :path, :string, "item Id", required: true
    end
    response(200, "Ok", Schema.ref(:DeleteList))
  end

  defp list_archived?(%{list: %{archived: true}}), do: true
  defp list_archived?(_), do: false

  def swagger_definitions do
    %{
      TotalItems:
      swagger_schema do
        title("Items")
        description("Items details")

        example(%{})
      end,
      CreateItem:
        swagger_schema do
          title("item Schema")
          description("item Schema")

          properties do
              list_id(:boolean, "list_id", required: true)
              completed(:boolean, "completed", required: true)
            content(:string, "content", required: true)
          end
          example(%{
            list_id: "sdfgdfgzdfgsdfgsdfgsdfg",
            completed: true,
            content: "dummy content",

          })
        end,
        SingleItem:
      swagger_schema do
        title("Single item")
        description("item details")

        example(%{})
      end,
      UpdateItem:
      swagger_schema do
        title("update item")
        description("update item details")

        properties do
          id(:string, "id", required: true)
        completed(:boolean, "completed", required: true)
        list_id(:string, "list_id", required: true)
      end
        example(%{
          list_id: "4c27de4f-ea2b-44bc-a871-b6f477b7417d",
          completed: true,
          content: "dummy content",
          id: "4c27de4f-ea2b-44bc-a871-b6f477b7417d"

        })
      end,
      DeleteItem:
      swagger_schema do
        title("Delete item")
        description("Delete item details")

        properties do
          id(:string, "id", required: true)
      end

        example(%{})
      end,
    }
  end
end
