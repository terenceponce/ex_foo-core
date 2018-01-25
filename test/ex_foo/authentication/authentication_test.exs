defmodule ExFoo.AuthenticationTest do
  use ExFoo.DataCase
  import ExFoo.Factory

  alias ExFoo.Authentication

  describe "users" do
    alias ExFoo.Authentication.User

    @valid_attrs %{email: "test@example.com", encrypted_password: "some encrypted_password"}
    @update_attrs %{email: "updated@example.com", encrypted_password: "some updated encrypted_password"}
    @invalid_attrs %{email: nil, encrypted_password: nil}

    test "list_users/0 returns all users" do
      users = insert_list(3, :user, %{encrypted_password: "abcdef12345"})
      assert Authentication.list_users() == users
    end

    test "get_user/1 returns the user with given id" do
      user = insert(:user)
      assert Authentication.get_user(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Authentication.create_user(@valid_attrs)
      assert user.email == "test@example.com"
      assert user.encrypted_password == "some encrypted_password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, user} = Authentication.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "updated@example.com"
      assert user.encrypted_password == "some updated encrypted_password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Authentication.update_user(user, @invalid_attrs)
      assert user == Authentication.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Authentication.delete_user(user)
      assert Authentication.get_user(user.id) == nil
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Authentication.change_user(user)
    end
  end
end
