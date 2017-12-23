defmodule Right do
  @moduledoc """
  A `Right` contains any value that is not a nil.
  """
  @enforce_keys [:value]
  defstruct [:value]
  defdelegate new(value), to: Either

  @doc """
  Applies the given function to the value contained inside the `Right`. Returns a
  new `Right` with the result of that calculation inside it.
  """
  def map(%Right{value: value}, func) do
    Either.new(func.(value))
  end

  @doc """
  Returns the result of the right hand function (the 3rd argument) applied to the value
  contained inside the `Right`. This defaults to the identity function, as a fold is
  where we usually want to 'unwarap' the value.
  """
  def fold(%Right{value: value}, _left_function, right_function \\ fn(x) -> x end) do
    right_function.(value)
  end
end
