defmodule ResultTest do
  use ExUnit.Case, async: true

  describe "Lift" do
    test "Puts a value into an Ok type" do
      assert Result.lift(%Ok{}, 10) == %Ok{value: 10}
    end

    test "If it's already an Ok it doesn't nest it" do
      assert Result.lift(%Ok{}, %Ok{value: 10}) == %Ok{value: 10}
    end

    test "if handed an error returns that error" do
      assert Result.lift(%Ok{}, %Error{value: "Thing"}) == %Error{value: "Thing"}
    end

    test "%Ok{} and {:error}" do
      assert Result.lift(%Ok{}, {:error, "Thing"}) == {:error, "Thing"}
    end

    test "%Ok{} and {:ok}" do
      assert Result.lift(%Ok{}, {:ok, "Thing"}) == %Ok{value: "Thing"}
    end
  end

  describe "Lift - tuple" do
    test "Puts a value into an Ok type" do
      assert Result.lift({:ok}, 10) == {:ok, 10}
    end

    test "If it's already an Ok it doesn't nest it" do
      assert Result.lift({:ok}, {:ok, 10}) == {:ok, 10}
    end

    test "if handed an error returns that error" do
      assert Result.lift({:ok}, {:error, "Thing"}) == {:error, "Thing"}
      # Should this flatten the {:error } ?????
      assert Result.lift({:ok}, {:error, {:error, "Thing"}}) == {:error, {:error, "Thing"}}
    end

    test "{:ok} and %Error{}" do
      assert Result.lift({:ok}, %Error{value: "Thing"}) == %Error{value: "Thing"}

      assert Result.lift({:ok}, %Error{value: {:error, "Thing"}}) == %Error{
               value: {:error, "Thing"}
             }
    end

    test "{:ok} and %Ok{}" do
      assert Result.lift({:ok}, %Ok{value: 10}) == {:ok, 10}
    end
  end

  describe "Lift error" do
    test "Puts a value into an Ok type" do
      assert Result.lift(%Error{}, 10) == %Error{value: 10}
    end

    test "If it's already an Ok it leaves it as that" do
      assert Result.lift(%Error{}, %Ok{value: 10}) == %Ok{value: 10}
    end

    test "if handed an error returns that error" do
      assert Result.lift(%Error{}, %Error{value: "Thing"}) == %Error{value: "Thing"}
    end

    test "%Error{} and {:error}" do
      assert Result.lift(%Error{}, {:error, "Thing"}) == %Error{value: "Thing"}
    end

    test "%Error{} and {:ok}" do
      assert Result.lift(%Error{}, {:ok, "Thing"}) == {:ok, "Thing"}
    end
  end

  describe "Lift error tuple" do
    test "Puts a value into an Ok type" do
      assert Result.lift({:error}, 10) == {:error, 10}
    end

    test "If it's already an Ok it leaves it as that" do
      assert Result.lift({:error}, {:ok, 10}) == {:ok, 10}
    end

    test "if handed an error returns that error" do
      assert Result.lift({:error}, {:error, "Thing"}) == {:error, "Thing"}
    end

    test "{:error} and %Error{}" do
      assert Result.lift({:error}, %Error{value: "Thing"}) == {:error, "Thing"}
    end

    test "{:error} and %Ok{}" do
      assert Result.lift({:error}, %Ok{value: "Thing"}) == %Ok{value: "Thing"}
    end
  end
end
