defmodule ExFooWeb.Router do
  use ExFooWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExFooWeb do
    pipe_through :api
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
