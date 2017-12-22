defmodule Left do
  @enforce_keys [:value]
  defstruct [:value]
  defdelegate new(value), to: Either

  def map(%Left{value: value}, _function) do
    Either.new(value)
  end

  def fold(%Left{value: value}, left_function, _right_function \\ fn(x) -> x end) do
    left_function.(value)
  end
end
