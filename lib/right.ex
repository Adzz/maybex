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
  def map(%Right{value: value}, func) when is_function(value) do
    value
    |> compose(func)
    |> Either.new()
  end
  def map(right = %Right{}, %Right{value: value}) do
    map(right, value)
  end
  def map(%Right{value: value}, func) do
    func = curry(func)
    value
    |> func.()
    |> Either.new()
  end

  @doc """
  Returns the result of the right hand function (the 3rd argument) applied to the value
  contained inside the `Right`. This defaults to the identity function, as a fold is
  where we usually want to 'unwarap' the value.
  """
  def fold(%Right{value: value}, _left_function, right_function \\ fn(x) -> x end) do
    right_function.(value)
  end

  defp compose(f, g) when is_function(g) do
    fn arg -> compose(f, g.(arg)) end
    fn arg -> compose(curry(f), curry(g).(arg)) end
  end
  defp compose(f, arg) do
    f.(arg)
  end

  defp curry(fun) do
    {_, arity} = :erlang.fun_info(fun, :arity)
    curry(fun, arity, [])
  end
  defp curry(fun, 0, arguments) do
    apply(fun, Enum.reverse arguments)
  end
  defp curry(fun, arity, arguments) do
    fn arg -> curry(fun, arity - 1, [arg | arguments]) end
  end
end
