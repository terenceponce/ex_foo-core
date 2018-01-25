defmodule ExFoo.Factory do
  use ExMachina.Ecto, repo: ExFoo.Repo

  alias ExFoo.Authentication.User

  def user_factory do
    %User{
      email: sequence(:email, &"test-#{&1}@example.com"),
      encrypted_password: "1234abcd"
    }
  end
end
