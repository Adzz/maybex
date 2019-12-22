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
  end

  describe "Lift error" do
    test "Puts a value into an Ok type" do
      assert Result.lift(%Error{}, 10) == %Error{value: 10}
    end

    test "If it's already an Ok it doesn't nest it" do
      assert Result.lift(%Error{}, %Ok{value: 10}) == %Ok{value: 10}
    end

    test "if handed an error returns that error" do
      assert Result.lift(%Error{}, %Error{value: "Thing"}) == %Error{value: "Thing"}
    end
  end
end
