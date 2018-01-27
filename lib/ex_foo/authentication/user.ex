defmodule ExFoo.Authentication.User do
  @moduledoc """
  User model
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Argon2
  alias ExFoo.Authentication.User

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @valid_email_format ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @doc false
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_format(:email, @valid_email_format)
    |> unique_constraint(:email)
  end

  @doc false
  def register_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password])
    |> validate_confirmation(:password, message: "does not match password", required: true)
    |> put_password_hash()
  end

  @doc false
  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :encrypted_password, Argon2.hashpwsalt(password))
  end
  defp put_password_hash(changeset), do: changeset
end
