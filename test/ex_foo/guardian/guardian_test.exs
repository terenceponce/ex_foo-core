defmodule ExFoo.GuardianTest do
  use ExFoo.DataCase
  import ExFoo.Factory

  alias ExFoo.Guardian

  setup do
    {:ok, user: insert(:user, id: 111)}
  end

  describe "#subject_for_token" do
    test "with valid user object returns {:ok, 'User:ID'}", %{user: user} do
      assert Guardian.subject_for_token(user, nil) == {:ok, "User:111"}
    end

    test "with invalid user object returns {:error, :unknown_resource}" do
      assert Guardian.subject_for_token(%{hello: "world"}, nil) == {:error, :unknown_resource}
    end
  end

  describe "#resource_from_claims" do
    test "with valid User sub in token returns {:ok, %User{}}", %{user: user} do
      assert Guardian.resource_from_claims(%{"sub" => "User:111"}) == {:ok, user}
    end

    test "with non-existent User sub in token returns {:error, :no_result}" do
      assert Guardian.resource_from_claims(%{"sub" => "User:123"}) == {:error, :no_result}
    end

    test "with invalid sub in token returns {:error, :invalid_claim}" do
      assert Guardian.resource_from_claims(%{"sub" => "Test:123"}) == {:error, :invalid_claim}
    end
  end
end
