defmodule TodoList.ItemsTest do
  use TodoList.DataCase

  alias TodoList.Items

  describe "items" do
    alias TodoList.Items.Item

    import TodoList.ItemsFixtures

    @invalid_attrs %{completed: nil, content: nil, list_id: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{completed: true, content: "some content", list_id: "some list_id"}

      assert {:ok, %Item{} = item} = Items.create_item(valid_attrs)
      assert item.completed == true
      assert item.content == "some content"
      assert item.list_id == "some list_id"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{completed: false, content: "some updated content", list_id: "some updated list_id"}

      assert {:ok, %Item{} = item} = Items.update_item(item, update_attrs)
      assert item.completed == false
      assert item.content == "some updated content"
      assert item.list_id == "some updated list_id"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end
