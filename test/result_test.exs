defmodule ResultTest do
  use ExUnit.Case, async: true

  describe "Lift" do
    test "Puts a value into an Ok type" do
      assert Result.lift(%Maybe.Ok{}, 10) == %Maybe.Ok{value: 10}
    end

    test "If it's already an Ok it doesn't nest it" do
      assert Result.lift(%Maybe.Ok{}, %Maybe.Ok{value: 10}) == %Maybe.Ok{value: 10}
    end

    test "if handed an error returns that error" do
      assert Result.lift(%Maybe.Ok{}, %Maybe.Error{value: "Thing"}) == %Maybe.Error{
               value: "Thing"
             }
    end

    test "%Maybe.Ok{} and {:error}" do
      assert Result.lift(%Maybe.Ok{}, {:error, "Thing"}) == {:error, "Thing"}
    end

    test "%Maybe.Ok{} and {:ok}" do
      assert Result.lift(%Maybe.Ok{}, {:ok, "Thing"}) == %Maybe.Ok{value: "Thing"}
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

    test "{:ok} and %Maybe.Error{}" do
      assert Result.lift({:ok}, %Maybe.Error{value: "Thing"}) == %Maybe.Error{value: "Thing"}

      assert Result.lift({:ok}, %Maybe.Error{value: {:error, "Thing"}}) == %Maybe.Error{
               value: {:error, "Thing"}
             }
    end

    test "{:ok} and %Maybe.Ok{}" do
      assert Result.lift({:ok}, %Maybe.Ok{value: 10}) == {:ok, 10}
    end
  end

  describe "Lift error" do
    test "Puts a value into an Ok type" do
      assert Result.lift(%Maybe.Error{}, 10) == %Maybe.Error{value: 10}
    end

    test "If it's already an Ok it leaves it as that" do
      assert Result.lift(%Maybe.Error{}, %Maybe.Ok{value: 10}) == %Maybe.Ok{value: 10}
    end

    test "if handed an error returns that error" do
      assert Result.lift(%Maybe.Error{}, %Maybe.Error{value: "Thing"}) == %Maybe.Error{
               value: "Thing"
             }
    end

    test "%Maybe.Error{} and {:error}" do
      assert Result.lift(%Maybe.Error{}, {:error, "Thing"}) == {:error, "Thing"}
    end

    test "%Maybe.Error{} and {:ok}" do
      assert Result.lift(%Maybe.Error{}, {:ok, "Thing"}) == {:ok, "Thing"}
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

    test "{:error} and %Maybe.Error{}" do
      assert Result.lift({:error}, %Maybe.Error{value: "Thing"}) == {:error, "Thing"}
    end

    test "{:error} and %Maybe.Ok{}" do
      assert Result.lift({:error}, %Maybe.Ok{value: "Thing"}) == %Maybe.Ok{value: "Thing"}
    end
  end
end
