defmodule ExFooWeb.Router do
  use ExFooWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExFooWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :ex_foo,
      swagger_file: "swagger.json",
      disable_validator: true
  end

  def swagger_info do
    %{
      info: %{
        version: "0.1.0",
        title: "Ex Foo"
      }
    }
  end
end
