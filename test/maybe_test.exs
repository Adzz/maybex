defmodule MaybeTest do
  use ExUnit.Case

  describe ".map/2" do
    test "Mapping a left will return the left unchanged" do
      left = Either.new(nil)
      assert Maybe.map(left, fn (_)-> "this wont run" end) == left
    end

    test "Mapping a right will run the function on the value contained in the right" do
      right = Either.new(10)
      assert Maybe.map(right, fn (x)-> x+10 end) == %Right{value: 20}
    end

    test "Mapping over a right that returns a nil should return a left" do
      right = Either.new(10)
      assert Maybe.map(right, fn (_)-> nil end) == %Left{value: nil}
    end
  end

  describe "./safe_pipe/3" do
    test "runs else_function on the value wrapped in the Left if passed a left, returns a the result wrapped" do
      left = Either.new(nil)
      assert Maybe.safe_pipe(left, fn (_) -> nil end, fn (_) -> "this wont run" end) == %Left{value: nil}
    end

    test "if passed a right runs the if_function on the value wrapped in the right and returns the result wrapped" do
      right = Either.new(10)
      assert Maybe.safe_pipe(right, fn(_)->"this wont run" end, fn(x)-> x + 10 end) == %Right{value: 20}
    end
  end

  describe ".fold/3" do
    test "If given a right it will run the right hand function in the fold (the third arg) on the value wrapped in the right, and return the result unwrapped" do
      right = Either.new(10)
      assert Maybe.fold(right, fn(_)-> "this wont run" end, fn(x)-> x + 10 end) == 20
    end

    test "If given a left it will run the left hand function (the second arg) and return the result unwrapped" do
      left = Either.new(nil)
      assert Maybe.fold(left, fn(_)-> ":(" end, fn(_)->"This wont run" end) == ":("
    end
  end

  describe ".fold/2" do
    test "If given a right it will default to returning the value wrapped in it" do
      right = Either.new(10)
      assert Maybe.fold(right, fn(_)-> "this wont run" end) == 10
    end
  end
end
