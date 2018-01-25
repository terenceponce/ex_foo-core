defmodule ExFoo.Authentication.User do
  @moduledoc """
  User model
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias ExFoo.Authentication.User

  schema "users" do
    field :email, :string
    field :encrypted_password, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password])
    |> validate_required([:email, :encrypted_password])
  end
end
