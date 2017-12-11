defmodule Either do
  @moduledoc """
  This is what you use to wrap a value that might be nil.
  """

  @doc """
  When a value is wrapped by this function it will return either a `Right` if the value is not
  nil, or a `Left` if the value passed in is nil. The `Left` implements the map and fold functions
  differently from the `Right`. This means you can pipe the result directly into a chain of Maybe
  function.

  Effectively this allows stuff like this to happen:

  ```
  iex> Either.new(nil)
  ...> %Left{value nil}

  iex> Either.new(10)
  ...> %Rigt{value: 10}

  iex> Either.new(nil) |> Maybe.map(fn(_) "this wont run" end)
  ...> %Left{value: nil}

  iex> Either.new(10) |> Maybe.map(fn(x) x + 10 end)
  ...> %Right{value: 20}
  """
  def new(value) do
    if value do
      Right.new(value)
    else
      Left.new(value)
    end
  end
end
