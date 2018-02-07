defmodule ExFooWeb.ErrorViewTest do
  use ExFooWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ExFooWeb.ErrorView, "404.json", []) == %{
             code: "404",
             message: "Resource not found"
           }
  end

  test "render 500.json" do
    assert render(ExFooWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal server error"}}
  end

  test "render any other" do
    assert render(ExFooWeb.ErrorView, "505.json", []) ==
             %{errors: %{detail: "Internal server error"}}
  end
end
