defmodule ExFoo.Authentication do
  @moduledoc """
  The Authentication context.
  """

  import Ecto.Query, warn: false
  alias ExFoo.Repo

  alias ExFoo.Authentication.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user using a field other than ID.

  ## Examples

      iex> get_user_by(%{email: "valid@example.com"})
      %User{}

      iex> get_user_by(%{invalid: "value"})
      nil

  """
  def get_user_by(map) when map_size(map) == 1, do: Repo.get_by(User, map)

  @doc """
  Creates a user.

  ## Examples

      iex> attrs = %{
      ...>   email: "test@example.com",
      ...>   password: "validpassword",
      ...>   password_confirmation: "validpassword"
      ...> }
      iex> create_user(attrs)
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
