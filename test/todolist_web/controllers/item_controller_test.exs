defmodule TodoListWeb.ItemControllerTest do
  use TodoListWeb.ConnCase

  import TodoList.ItemsFixtures

  alias TodoList.Items.Item

  @create_attrs %{
    completed: true,
    content: "some content",
    list_id: "some list_id"
  }
  @update_attrs %{
    completed: false,
    content: "some updated content",
    list_id: "some updated list_id"
  }
  @invalid_attrs %{completed: nil, content: nil, list_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, ~p"/api/items")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create item" do
    test "renders item when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/items", item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/items/#{id}")

      assert %{
               "id" => ^id,
               "completed" => true,
               "content" => "some content",
               "list_id" => "some list_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/items", item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update item" do
    setup [:create_item]

    test "renders item when data is valid", %{conn: conn, item: %Item{id: id} = item} do
      conn = put(conn, ~p"/api/items/#{item}", item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/items/#{id}")

      assert %{
               "id" => ^id,
               "completed" => false,
               "content" => "some updated content",
               "list_id" => "some updated list_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/api/items/#{item}", item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, ~p"/api/items/#{item}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/items/#{item}")
      end
    end
  end

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end
end
