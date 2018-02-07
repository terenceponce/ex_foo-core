defmodule ExFooWeb.UserController do
  use ExFooWeb, :controller
  use PhoenixSwagger

  alias ExFoo.Authentication, as: AuthContext
  alias ExFoo.Authentication.User

  action_fallback(ExFooWeb.FallbackController)

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the platform")

          properties do
            id(:string, "ID of the user", required: true)
            email(:string, "Email address of the user", required: true)
            inserted_at(:string, "When the user was created", format: "ISO-8601")
            updated_at(:string, "When the user was last modified", format: "ISO-8601")
          end

          example(%{
            id: "123",
            email: "test@example.com",
            inserted_at: "2018-01-25T14:00:00Z",
            updated_at: "2018-01-25T14:00:00Z"
          })
        end,
      Users:
        swagger_schema do
          title("Users")
          description("A collection of users")
          type(:array)
          items(Schema.ref(:User))
        end,
      Error:
        swagger_schema do
          title("Error")
          description("Error responses from the API")

          properties do
            code(:string, "The status code of the error", required: true)
            message(:string, "The detail of the error raised", required: true)
            field(:string, "Field / Attribute that was affected")
          end
        end,
      Errors:
        swagger_schema do
          title("Errors")
          description("A collection of errors")
          type(:array)
          items(Schema.ref(:Error))
        end
    }
  end

  swagger_path :index do
    get("/users")
    summary("List all users")
    description("List all users registered in the platform")
    response(200, "Ok", Schema.ref(:Users))
  end

  def index(%{assigns: %{version: :v1}} = conn, _params) do
    users = AuthContext.list_users()
    render(conn, "index.v1.json", users: users)
  end

  swagger_path :create do
    post("/users")
    summary("Add a new user")
    description("Register a new user to the platform")

    parameters do
      email(:query, :string, "Email Address of the user to be created", required: true)

      password(
        :query,
        :string,
        "Password that will be assigned to the user",
        required: true,
        format: "password"
      )

      password_confirmation(
        :query,
        :string,
        "Check to see if password has been written correctly",
        required: true,
        format: "password"
      )
    end

    response(201, "Ok", Schema.ref(:User))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(%{assigns: %{version: :v1}} = conn, params) do
    with {:ok, %User{} = user} <- AuthContext.create_user(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.v1.json", user: user)
    end
  end

  swagger_path :show do
    get("/users/{userId}")
    summary("Retrieve a user")
    description("Retrieve a user registered in the platform")

    parameters do
      id(:path, :string, "The ID of the user", required: true)
    end

    response(200, "Ok", Schema.ref(:User))
    response(404, "Not Found", Schema.ref(:Error))
  end

  def show(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    with %User{} = user <- AuthContext.get_user(id) do
      render(conn, "show.v1.json", user: user)
    end
  end

  swagger_path :update do
    patch("/users/{userId}")
    summary("Update an existing user")
    description("Update the details of an existing user")

    parameters do
      id(:path, :string, "The ID of the user", required: true)
      email(:query, :string, "The new email address of the user to be updated")
    end

    response(200, "Ok", Schema.ref(:User))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(%{assigns: %{version: :v1}} = conn, %{"id" => id} = params) do
    user = AuthContext.get_user(id)

    with {:ok, %User{} = user} <- AuthContext.update_user(user, params) do
      render(conn, "show.v1.json", user: user)
    end
  end

  swagger_path :delete do
    delete("/users/{userId}")
    summary("Delete a user")
    description("Remove a user from the platform")

    parameters do
      id(:path, :string, "The ID of the user", required: true)
    end

    response(204, "No Content")
    response(404, "Not Found")
  end

  def delete(%{assigns: %{version: :v1}} = conn, %{"id" => id}) do
    user = AuthContext.get_user(id)

    with {:ok, %User{}} <- AuthContext.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
