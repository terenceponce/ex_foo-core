defmodule ExFooWeb.TokenControllerTest do
  use ExFooWeb.ConnCase
  import ExFoo.Factory
  alias Comeonin.Argon2

  @valid_sign_in %{
    email: "test@example.com",
    password: "validpassword",
  }

  @invalid_sign_in %{
    email: "invalid@example.com",
    password: "invalidpassword",
  }

  setup %{conn: conn} do
    insert(
      :user,
      email: "test@example.com",
      encrypted_password: Argon2.hashpwsalt("validpassword")
    )

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "with valid credentials returns authorization header", %{conn: conn} do
      data = post(conn, token_path(conn, :create), @valid_sign_in)
      headers = Enum.into(data.resp_headers, %{})

      assert data.status == 200
      assert headers["authorization"] =~ "Bearer"
    end

    test "with invalid credentials returns 401 response", %{conn: conn} do
      data = post(conn, token_path(conn, :create), @invalid_sign_in)
      headers = Enum.into(data.resp_headers, %{})

      assert data.status == 401
      assert headers["authorization"] == nil
    end
  end
end
