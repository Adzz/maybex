defmodule MaybeTest do
  use ExUnit.Case, async: true
  doctest Maybe

  describe "map/2" do
    test "applies the fun to the value in the Ok if given an Ok" do
      times_ten = fn x -> x * 10 end
      assert Maybe.map(%Maybe.Ok{value: 10}, times_ten) == %Maybe.Ok{value: 100}
    end

    test "Returns the Error if given an Error" do
      times_ten = fn x -> x * 10 end
      assert Maybe.map(%Maybe.Error{value: 10}, times_ten) == %Maybe.Error{value: 10}
    end

    test "flattens a fun that returns an Ok" do
      fun = fn x -> %Maybe.Ok{value: x * 10} end
      assert Maybe.map(%Maybe.Ok{value: 10}, fun) == %Maybe.Ok{value: 100}
    end

    test "handles a fun that returns an Error" do
      fun = fn _ -> %Maybe.Error{value: "Nope"} end
      assert Maybe.map(%Maybe.Ok{value: 10}, fun) == %Maybe.Error{value: "Nope"}
    end

    test "handles mix and match" do
      assert %Maybe.Ok{value: 10}
             |> Maybe.map(fn x -> x * 10 end)
             |> Maybe.map(fn _x -> {:error, "Nope!"} end) == {:error, "Nope!"}
    end
  end

  describe "map/2 tuple impl" do
    test "applies the fun to the value in the Ok if given an Ok" do
      times_ten = fn x -> x * 10 end
      assert Maybe.map({:ok, 10}, times_ten) == {:ok, 100}
    end

    test "Returns the Error if given an Error" do
      times_ten = fn x -> x * 10 end
      assert Maybe.map({:error, 10}, times_ten) == {:error, 10}
    end

    test "flattens a fun that returns an Ok" do
      fun = fn x -> {:ok, x * 10} end
      assert Maybe.map({:ok, 10}, fun) == {:ok, 100}
    end

    test "handles a fun that returns an Error" do
      fun = fn _ -> {:error, "Nope"} end
      assert Maybe.map({:ok, 10}, fun) == {:error, "Nope"}
    end

    test "raises if given a tuple that we can't handle" do
      fun = fn _ -> {:ok, "Nope"} end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:error, 10, 10}",
                   fn ->
                     Maybe.map({:error, 10, 10}, fun)
                   end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:other, 10}",
                   fn ->
                     Maybe.map({:other, 10}, fun)
                   end
    end
  end

  describe "map_errors" do
    test "If given an error applies the fun to the value in it" do
      fun = fn msg -> msg <> " not at all" end

      assert Maybe.map_error(%Maybe.Error{value: "Nope"}, fun) == %Maybe.Error{
               value: "Nope not at all"
             }
    end

    test "if given an Ok, passes it through" do
      fun = fn msg -> msg <> " not at all" end
      assert Maybe.map_error(%Maybe.Ok{value: "Yes"}, fun) == %Maybe.Ok{value: "Yes"}
    end

    test "flattens a fun that returns an Error" do
      fun = fn x -> %Maybe.Error{value: x * 10} end
      assert Maybe.map_error(%Maybe.Error{value: 10}, fun) == %Maybe.Error{value: 100}
    end

    test "handles a fun that returns an Ok" do
      fun = fn _ -> %Maybe.Ok{value: "Nope"} end
      assert Maybe.map_error(%Maybe.Error{value: 10}, fun) == %Maybe.Ok{value: "Nope"}
    end
  end

  describe "map_errors - tuple impl" do
    test "If given an error applies the fun to the value in it" do
      fun = fn msg -> msg <> " not at all" end
      assert Maybe.map_error({:error, "Nope"}, fun) == {:error, "Nope not at all"}
    end

    test "if given an Ok, passes it through" do
      fun = fn msg -> msg <> " not at all" end
      assert Maybe.map_error({:ok, "Yes"}, fun) == {:ok, "Yes"}
    end

    test "flattens a fun that returns an Error" do
      fun = fn x -> {:error, x * 10} end
      assert Maybe.map_error({:error, 10}, fun) == {:error, 100}
    end

    test "handles a fun that returns an Ok" do
      fun = fn _ -> {:ok, "Nope"} end
      assert Maybe.map_error({:error, 10}, fun) == {:ok, "Nope"}
    end

    test "raises if given a tuple that we can't handle" do
      fun = fn _ -> {:ok, "Nope"} end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:error, 10, 10}",
                   fn ->
                     Maybe.map_error({:error, 10, 10}, fun)
                   end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:other, 10}",
                   fn ->
                     Maybe.map_error({:other, 10}, fun)
                   end
    end
  end

  describe "unwrap!" do
    test "Returns the value within the ok" do
      assert Maybe.unwrap!(%Maybe.Ok{value: 10}) == 10
    end

    test "Raises an error with the value inside an Error" do
      assert_raise RuntimeError, "Error: Fluffed it", fn ->
        Maybe.unwrap!(%Maybe.Error{value: "Fluffed it"})
      end
    end
  end

  describe "unwrap! - tuple impl" do
    test "Returns the value within the ok" do
      assert Maybe.unwrap!({:ok, 10}) == 10
    end

    test "Raises an error with the value inside an Error" do
      assert_raise RuntimeError, "Error: Fluffed it", fn ->
        Maybe.unwrap!({:error, "Fluffed it"})
      end
    end

    test "raises if given a tuple that we can't handle" do
      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:error, 10, 10}",
                   fn ->
                     Maybe.unwrap!({:error, 10, 10})
                   end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:other, 10}",
                   fn ->
                     Maybe.unwrap!({:other, 10})
                   end
    end
  end

  describe "unwrap" do
    test "Returns the value within the ok" do
      assert Maybe.unwrap(%Maybe.Ok{value: 10}) == 10
    end

    test "Returns the value inside an Error" do
      assert Maybe.unwrap(%Maybe.Error{value: 10}) == 10
    end
  end

  describe "unwrap - tuple impl" do
    test "Returns the value within the ok" do
      assert Maybe.unwrap({:ok, 10}) == 10
    end

    test "Returns the value inside an Error" do
      assert Maybe.unwrap({:error, 10}) == 10
    end

    test "raises if given a tuple that we can't handle" do
      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:error, 10, 10}",
                   fn ->
                     Maybe.unwrap({:error, 10, 10})
                   end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:other, 10}",
                   fn ->
                     Maybe.unwrap({:other, 10})
                   end
    end
  end

  describe "unwrap_or_else" do
    test "Returns the value within the ok" do
      fun = fn x -> raise x end
      assert Maybe.unwrap_or_else(%Maybe.Ok{value: 10}, fun) == 10
    end

    test "If given an error applies fun to the value inside and returns the result" do
      fun = fn x -> x + 10 end
      assert Maybe.unwrap_or_else(%Maybe.Error{value: 10}, fun) == 20
    end
  end

  describe "unwrap_or_else - tuple impl" do
    test "Returns the value within the ok" do
      fun = fn x -> raise x end
      assert Maybe.unwrap_or_else({:ok, 10}, fun) == 10
    end

    test "If given an error applies fun to the value inside and returns the result" do
      fun = fn x -> x + 10 end
      assert Maybe.unwrap_or_else({:error, 10}, fun) == 20
    end

    test "raises if given a tuple that we can't handle" do
      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:error, 10, 10}",
                   fn ->
                     Maybe.unwrap!({:error, 10, 10})
                   end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:other, 10}",
                   fn ->
                     Maybe.unwrap!({:other, 10})
                   end
    end
  end

  describe "is_error?" do
    test "true for Error" do
      assert Maybe.is_error?(%Maybe.Error{value: nil})
    end

    test "false for Ok" do
      refute Maybe.is_error?(%Maybe.Ok{value: nil})
    end
  end

  describe "is_error? - tuple impl" do
    test "true for Error" do
      assert Maybe.is_error?({:error, nil})
    end

    test "false for Ok" do
      refute Maybe.is_error?({:ok, nil})
    end

    test "raises if given a tuple that we can't handle" do
      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:error, 10, 10}",
                   fn ->
                     Maybe.is_error?({:error, 10, 10})
                   end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:other, 10}",
                   fn ->
                     Maybe.is_error?({:other, 10})
                   end
    end
  end

  describe "is_ok?" do
    test "false for Error" do
      refute Maybe.is_ok?(%Maybe.Error{value: nil})
    end

    test "true for Ok" do
      assert Maybe.is_ok?(%Maybe.Ok{value: nil})
    end
  end

  describe "is_ok? - tuple impl" do
    test "false for Error" do
      refute Maybe.is_ok?({:error, nil})
    end

    test "true for Ok" do
      assert Maybe.is_ok?({:ok, nil})
    end

    test "raises if given a tuple that we can't handle" do
      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:error, 10, 10}",
                   fn ->
                     Maybe.is_ok?({:error, 10, 10})
                   end

      assert_raise RuntimeError,
                   "Tuple must be in the form {:ok, result} | {:error, error} got {:other, 10}",
                   fn ->
                     Maybe.is_ok?({:other, 10})
                   end
    end
  end
end
