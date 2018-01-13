defmodule MaybeTest do
  use ExUnit.Case

  describe ".map/2" do
    setup do
      %{
        right: Either.new(10),
        left: Either.new(nil),
      }
    end

    test "Mapping a left will return the left unchanged", %{left: left} do
      assert Maybe.map(left, fn (_)-> "this wont run" end) == left
    end

    test "Mapping a right will run the function on the value contained in the right", %{right: right} do
      assert Maybe.map(right, fn (x)-> x + 10 end) == %Right{value: 20}
    end

    test "Mapping over a right that returns a nil should return a left", %{right: right} do
      assert Maybe.map(right, fn (_) -> nil end) == %Left{value: nil}
    end

    test "it will partially apply a function", %{right: right} do

      assert Maybe.map(right, fn (x, y) -> x + y end).value.(20) == 30
    end
  end

  describe "./safe_pipe/3" do
    setup do
      %{
        right: Either.new(10),
        left: Either.new(nil),
      }
    end

    test "runs else_function on the value wrapped in the Left if passed a left, returns a the result wrapped", %{left: left} do
      assert Maybe.safe_pipe(left, fn (_) -> nil end, fn (_) -> "this wont run" end) == %Left{value: nil}
    end

    test "if passed a right runs the if_function on the value wrapped in the right and returns the result wrapped", %{right: right} do
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
