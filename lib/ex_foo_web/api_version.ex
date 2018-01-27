defmodule ExFooWeb.APIVersion do
  @versions Application.get_env(:plug, :mimes)
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    [accept] = get_req_header(conn, "accept")
    version = Map.fetch(@versions, accept)
    _call(conn, version)
  end

  defp _call(conn, {:ok, [version]}) do
    assign(conn, :version, version)
  end
  defp _call(conn, _) do
    # If the API client did not specify anything, just assign the latest version
    assign(conn, :version, :v1)
  end
end
