defmodule ExFooWeb.UserControllerTest do
  use ExFooWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"
  import ExFoo.Factory

  @create_attrs %{
    email: "test@example.com",
    password: "validpassword",
    password_confirmation: "validpassword"
  }
  @update_attrs %{email: "updated@example.com"}
  @invalid_attrs %{email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn, swagger_schema: schema} do
      user = insert(:user)
      user2 = insert(:user)

      data =
        conn
        |> get(user_path(conn, :index))
        |> validate_resp_schema(schema, "Users")
        |> json_response(200)

      expected_result = [
        %{
          "id" => "#{user.id}",
          "email" => user.email,
          "inserted_at" => NaiveDateTime.to_iso8601(user.inserted_at),
          "updated_at" => NaiveDateTime.to_iso8601(user.updated_at)
        },
        %{
          "id" => "#{user2.id}",
          "email" => user2.email,
          "inserted_at" => NaiveDateTime.to_iso8601(user2.inserted_at),
          "updated_at" => NaiveDateTime.to_iso8601(user2.updated_at)
        }
      ]

      assert expected_result == data
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn, swagger_schema: schema} do
      data =
        conn
        |> post(user_path(conn, :create), @create_attrs)
        |> validate_resp_schema(schema, "User")
        |> json_response(201)

      refute data["id"] == nil
      assert data["email"] == "test@example.com"
      refute data["inserted_at"] == nil
      refute data["updated_at"] == nil
    end

    test "renders errors when data is invalid", %{conn: conn, swagger_schema: schema} do
      data =
        conn
        |> post(user_path(conn, :create), @invalid_attrs)
        |> validate_resp_schema(schema, "Errors")
        |> json_response(422)
        |> Enum.at(0)

      assert data["code"] == "422"
      assert data["field"] == "email"
      assert data["message"] == "can't be blank"
    end
  end

  describe "show user" do
    test "renders user when id is valid", %{conn: conn, swagger_schema: schema} do
      user = insert(:user)

      data =
        conn
        |> get(user_path(conn, :show, user))
        |> validate_resp_schema(schema, "User")
        |> json_response(200)

      assert data["id"] == "#{user.id}"
    end

    test "renders error when id is invalid", %{conn: conn, swagger_schema: schema} do
      data =
        conn
        |> get(user_path(conn, :show, 12345))
        |> validate_resp_schema(schema, "Error")
        |> json_response(404)

      assert data["code"] == "404"
      assert data["message"] == "Resource not found"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: user, swagger_schema: schema} do
      data =
        conn
        |> put(user_path(conn, :update, user), user: @update_attrs)
        |> validate_resp_schema(schema, "User")
        |> json_response(200)

      assert data["id"] == "#{user.id}"
      assert data["email"] == "updated@example.com"
      assert data["inserted_at"] == NaiveDateTime.to_iso8601(user.inserted_at)
      refute data["updated_at"] == NaiveDateTime.to_iso8601(user.updated_at)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user, swagger_schema: schema} do
      data =
        conn
        |> put(user_path(conn, :update, user), user: @invalid_attrs)
        |> validate_resp_schema(schema, "Errors")
        |> json_response(422)
        |> Enum.at(0)

      assert data["code"] == "422"
      assert data["field"] == "email"
      assert data["message"] == "can't be blank"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, user_path(conn, :delete, user))
      assert response(conn, 204)
    end
  end

  defp create_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end
end
