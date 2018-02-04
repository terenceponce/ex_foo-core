defmodule ExFoo.Guardian.Authentication do
  @moduledoc "Contains helpers that can be used for authentication"
  alias Comeonin.Argon2
  alias ExFoo.Authentication.User
  alias ExFoo.Guardian

  @doc """
  Compare a given string with the user's encrypted password
  and see if they match.

  ## Examples

      iex> verify_password(user, "correctpassword")
      %User{}

      iex> verify_password(user, "invalidpassword")
      nil

      iex> verify_password(nil, "correctpassword")
      nil

  """
  def verify_password(%User{} = user, password) do
    if Argon2.checkpw(password, user.encrypted_password) do
      user
    else
      nil
    end
  end

  @doc false
  def verify_password(nil, _password), do: nil

  @doc """
  Generate a token (JWT) to be used by the client for future requests.

  ## Examples

      iex> create_token(user)
      "1ndfsQlkjFlkqkjRandomStringForJWTfl15213MVskjf"

      iex> create_token(nil)
      nil

  """
  def create_token(user) do
    case Guardian.encode_and_sign(user) do
      {:ok, token, _claims} ->
        token

      _ ->
        nil
    end
  end

  @doc false
  def create_token(nil), do: nil
end
