defmodule ExFooWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ExFooWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(422)
    |> render(ExFooWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, nil) do
    conn
    |> put_status(404)
    |> render(ExFooWeb.ErrorView, "404.json")
  end
end
