defmodule Left do
  @moduledoc """
  A `Left` only ever contains a nil value.
  """

  @enforce_keys [:value]
  defstruct [value: nil]
  defdelegate new(value), to: Either

  @doc """
  The left map simply returns the left untouched.
  """
  def map(%Left{value: value}, _function) do
    Either.new(value)
  end

  @doc """
  The left fold applies the left function (the 2nd argument) to the value contained
  in the left. Usually you will want to ignore that argument (we know it will be
  nil). A good example of a function we might want here is one which logs some kind
  of error.
  """
  def fold(%Left{value: value}, left_function, _right_function \\ fn(x) -> x end) do
    left_function.(value)
  end

  defimpl Maybe do
    defdelegate map(left, function), to: Left
    defdelegate fold(left, left_function, right_function \\ fn(x) -> x end), to: Left

    def safe_pipe(%Left{value: value}, left_function, _right_function) do
      Either.new(left_function.(value))
    end
  end
end
