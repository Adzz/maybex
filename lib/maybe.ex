defmodule Left do
  @enforce_keys [:value]
  defstruct [:value]

  def new(value) do
    %Left{value: value}
  end
end

defmodule Right do
  @enforce_keys [:value]
  defstruct [:value]

  def new(value) do
    %Right{value: value}
  end
end

defprotocol Maybe do
  def map(left_or_right, function)
  def fold(left_or_right, left_function, right_function)
  # this is because the fold's right function has a default arg - the id function
  def fold(left_or_right, left_function)
end

defimpl Maybe, for: Left do
  def map(%Left{value: value}, _function) do
    Left.new(value)
  end

  def fold(%Left{value: value}, left_function, _right_function \\ fn(x) -> x end) do
    left_function.(value)
  end
end

defimpl Maybe, for: Right do
  def map(%Right{value: value}, func) do
    Right.new(func.(value))
  end

  def fold(%Right{value: value}, _left_function, right_function \\ fn(x) -> x end) do
    right_function.(value)
  end
end

defmodule Either do
  @moduledoc """
  This is what you use to wrap a value that might return nil.
  """

  @doc """
  When a value is wrapped by this function it will return either a `Right` if the value is not
  nil, or a `Left` if the value passed in is nil. The `Left` implements the map and fold functions
  differently from the `Right`. When we eventually fold the data out, we will be returned the result
  of the left_function if the thing being passed into the fold is a `Left`, and we will be returned
  the result of the right_function if the thing being passed into the fold is a `Right`.

  Effectively this allows stuff like this to happen:

  ```
  Either.new(function_that_might_return_nil("argument"))
  |> Maybe.fold(fn(x) -> "Whoops!" end, fn(x)-> x end)
  ```


  """
  def new(value) do
    if value do
      Right.new(value)
    else
      Left.new(value)
    end
  end
end
