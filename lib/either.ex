defmodule Either do
  @moduledoc """
  This is what you use to wrap a value that might be nil.

  An Either contains one function `new` whose job it is to produce either a `Right`
  or a `Left`
  """

  @doc """
  When a value is wrapped by this function it will return either a `Right` if the value is not
  nil, or a `Left` if the value passed in is nil. The `Left` implements the map and fold functions
  differently from the `Right`. This means you can safely pipe the result directly into a chain of Maybe
  functions.

  Effectively this allows stuff like this to happen:

  ```
  iex> Either.new(nil)
  ...> %Left{value nil}

  iex> Either.new(10)
  ...> %Rigt{value: 10}

  iex> Either.new(nil) |> Maybe.map(fn(_)-> "this wont run" end)
  ...> %Left{value: nil}

  iex> Either.new(10) |> Maybe.map(fn(x)-> x + 10 end)
  ...> %Right{value: 20}

  It also ensures that we dont end up with arbitrarily nested Lefts:

  iex> Either.new(10) |> Maybe.map(fn(_)-> Either.new(nil) end)
  ...> %Left{value: nil}

  iex> Either.new(10) |> Maybe.map(fn(_)-> %Left{value: nil} end)
  ...> %Left{value: nil}
  """
  def new(value) do
    case value do
      {:error, error} -> %Left{value: {:error, error}}
      :error -> %Left{value: {:error, :error}}
      nil -> %Left{value: value}
      %Left{value: value} -> new(value)
      %Right{value: value} -> new(value)
      value -> %Right{value: value}
    end
  end
end
