defmodule ExFooWeb.Router do
  use ExFooWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExFooWeb do
    pipe_through :api
  end
end
