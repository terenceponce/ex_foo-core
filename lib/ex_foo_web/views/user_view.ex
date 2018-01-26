defmodule ExFooWeb.UserView do
  use ExFooWeb, :view
  alias ExFooWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: "#{user.id}",
      email: user.email,
      inserted_at: NaiveDateTime.to_iso8601(user.inserted_at),
      updated_at: NaiveDateTime.to_iso8601(user.updated_at)
    }
  end
end
