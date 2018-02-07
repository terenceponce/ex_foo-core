defmodule ExFooWeb.ChangesetView do
  use ExFooWeb, :view
  alias Ecto.Changeset

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `ExFooWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    changeset
    |> translate_errors()
    |> generate_response()
  end

  defp generate_response(map) when map_size(map) > 0 do
    Enum.map(map, fn {k, v} -> %{code: "422", field: "#{k}", message: "#{v}"} end)
  end
end
