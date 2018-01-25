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

  @valid_email_format ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password])
    |> validate_required([:email, :encrypted_password])
    |> validate_format(:email, @valid_email_format)
  end
end
