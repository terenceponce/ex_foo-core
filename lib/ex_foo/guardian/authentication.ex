defmodule ExFoo.Guardian.Authentication do
  @moduledoc "Contains helpers that can be used for authentication"
  alias Comeonin.Argon2
  alias ExFoo.Authentication.User
  alias ExFoo.Guardian

  def verify_password(nil, _password), do: nil

  def verify_password(%User{} = user, password) do
    if Argon2.checkpw(password, user.encrypted_password) do
      user
    else
      nil
    end
  end

  def create_token(nil), do: nil

  def create_token(user) do
    case Guardian.encode_and_sign(user) do
      {:ok, token, _claims} ->
        token

      _ ->
        nil
    end
  end
end
