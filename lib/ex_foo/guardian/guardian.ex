defmodule ExFoo.Guardian do
  @moduledoc "Module required in order to use Guardian inside the app"
  use Guardian, otp_app: :ex_foo

  alias ExFoo.Authentication
  alias ExFoo.Authentication.User

  @doc """
  Encodes the user resource as the sub claim of the token to be passed to the client.

  ## Examples

      iex> attrs = %{email: "test@example.com", password: "password", password_confirmation: "password"}
      iex> {:ok, user} = Authentication.create_user(attrs)
      iex> user = %{user | id: 123}
      iex> subject_for_token(user, nil)
      {:ok, "User:123"}
      iex> invalid_user = %{hello: "world"}
      iex> subject_for_token(invalid_user, nil)
      {:error, :unknown_resource}
  """
  def subject_for_token(%User{} = user, _claims) do
    sub = "User:" <> to_string(user.id)
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  @doc ~S"""
  Decodes the user resource from the sub claim in the received token for authentication.

  ## Examples

      iex> attrs = %{email: "test@example.com", password: "password", password_confirmation: "password"}
      iex> {:ok, user} = Authentication.create_user(attrs)
      iex> resource_from_claims(%{"sub" => "User:#{user.id}"})
      {:ok, %User{}}
      iex> resource_from_claims(%{"sub" => "User:999"})
      {:error, :no_result}
      iex> resource_from_claims(%{"sub" => "Random:123"})
      {:error, :invalid_claim}
  """
  def resource_from_claims(%{"sub" => "User:" <> id}) do
    case Authentication.get_user(id) do
      nil -> {:error, :no_result}
      resource -> {:ok, resource}
    end
  end
  def resource_from_claims(_claims) do
    {:error, :invalid_claim}
  end
end
