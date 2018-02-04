defmodule ExFooWeb.TokenController do
  use ExFooWeb, :controller
  use PhoenixSwagger

  alias ExFoo.Authentication
  alias ExFoo.Guardian.Authentication, as: GuardianAuth

  action_fallback ExFooWeb.FallbackController

  swagger_path :create do
    post("/token")
    summary("Creates an authentication token")
    description("Creates an auth token that can be used to authorize subsequent requests")

    parameters do
      email(:query, :string, "Email address of a registered user", required: true)
      password(
        :query,
        :string,
        "The corresponding password of the registered user",
        required: true,
        format: "password"
      )
    end
    response(200, "Ok", %{}, headers: %{
      "Authorization": %{
        description: "Contains the token (JWT) that the API client can use to authenticate in subsequent requests",
        type: :string
      }
    })
    response(401, "Unauthorized", Schema.ref(:Error))
  end

  def create(%{assigns: %{version: :v1}} = conn, %{"email" => email, "password" => password}) do
    user = Authentication.get_user_by(%{email: email})
    token = user
      |> GuardianAuth.verify_password(password)
      |> GuardianAuth.create_token()

    if token do
      conn
      |> put_resp_header("authorization", "Bearer #{token}")
      |> send_resp(200, token)
    else
      send_resp(conn, 401, "")
    end
  end
end
