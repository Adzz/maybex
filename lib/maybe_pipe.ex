defmodule Maybe.Pipe do
  @moduledoc ~S"""
  Macro for piping conditionally into the next function. This is an alias for the function Maybe.map/2

  If the value piped in is an error tuple the next function in the pipe
  will not be called and the value is returned.

  iex> import Maybe.Pipe; {:error, 5} ~> Kernel.+(2)
  {:error, 5}

  If the value piped in is an ok tuple it will be flattened to just the
  value contained within the tuple when passed to functions in the pipe.

  The value finally returned from the pipe will be an ok/error tuple.

  iex> import Maybe.Pipe;  {:ok, 5} ~> &Kernel.+(&1, 2)
  {:ok, 7}

  iex> import Maybe.Pipe;
  ...> {:ok, 5} ~> fn x -> x + 2 end ~> fn x -> x + 3 end
  {:ok, 10}

  For more information about the motivation for this macro you can start reading about
  [point-free programming](https://en.wikipedia.org/wiki/Tacit_programming).
  It solves one of the two hardest problems in programming: naming things.
  """
  defmacro left ~> right do
    quote do
      Maybe.map(unquote(left), unquote(right))
    end
  end
end
