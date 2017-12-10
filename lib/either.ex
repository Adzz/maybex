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
  """
  def new(value) do
    if value do
      Right.new(value)
    else
      Left.new(value)
    end
  end
end
