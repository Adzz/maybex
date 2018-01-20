defmodule EitherTest do
  use ExUnit.Case

  test "Returns a left if initialized with nil" do
    assert Either.new(nil) == %Left{value: nil}
    assert Either.new(:error) == %Left{value: {:error, :error}}
    assert Either.new({:error, :not_found}) == %Left{value: {:error, :not_found}}
    assert Either.new({:error, :error}) == %Left{value: {:error, :error}}
  end

  test "Returns a right if initialized with a value that is not nil" do
    # should use property based tests here
    assert Either.new(true) == %Right{value: true}
    assert Either.new("") == %Right{value: ""}
    assert Either.new(10) == %Right{value: 10}
    assert Either.new(false) == %Right{value: false}
  end
end
