defmodule Right do
  @enforce_keys [:value]
  defstruct [:value]
  defdelegate new(value), to: Either

  def map(%Right{value: value}, func) do
    Either.new(func.(value))
  end

  def fold(%Right{value: value}, _left_function, right_function \\ fn(x) -> x end) do
    right_function.(value)
  end
end
