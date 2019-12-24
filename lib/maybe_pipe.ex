defmodule Maybe.Pipe do
  @moduledoc ~S"""
  Macro for piping conditionally into the next function.

  If the value piped in is an error tuple the next function in the pipe
  will not be called and the value is returned.

  iex> {:error, 5} ~> Kernel.+(2)
  {:error, 5}

  If the value piped in is an ok tuple it will be flattened to just the
  value contained within the tuple when passed to functions in the pipe.

  The value finally returned from the pipe will be an ok/error tuple.

  iex> {:ok, 5} ~> Kernel.+(2)
  {:ok, 7}

  iex> {:ok, 5} ~> Kernel.+(2) ~> Kernel.+(3)
  {:ok, 10}

  If the value piped in is not an ok/error tuple a IncorrectMaybePipeError will be raised.

  In cases where a non-tuple value needs to be passed in a regular pipe (|>) should
  be used instead.

  For more information about the motivation for this macro you can start reading about
  [point-free programming](https://en.wikipedia.org/wiki/Tacit_programming).
  It solves one of the two hardest problems in programming: naming things.
  """
  defmacro left ~> right do
    quote do
      unquote(left) |> Maybe.map(unquote(right))
    end
  end
end
