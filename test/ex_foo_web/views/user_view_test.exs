defmodule ExFooWeb.UserViewTest do
  use ExFooWeb.ConnCase, async: true
  import ExFoo.Factory
  alias ExFooWeb.UserView

  setup do
    {:ok, user: insert(:user)}
  end

  test "index.v1.json", %{user: user} do
    rendered_result = UserView.render("index.v1.json", %{users: [user]})

    assert rendered_result == [
             %{
               id: "#{user.id}",
               email: user.email,
               inserted_at: NaiveDateTime.to_iso8601(user.inserted_at),
               updated_at: NaiveDateTime.to_iso8601(user.updated_at)
             }
           ]
  end

  test "show.v1.json", %{user: user} do
    rendered_result = UserView.render("show.v1.json", %{user: user})

    assert rendered_result == %{
             id: "#{user.id}",
             email: user.email,
             inserted_at: NaiveDateTime.to_iso8601(user.inserted_at),
             updated_at: NaiveDateTime.to_iso8601(user.updated_at)
           }
  end
end
