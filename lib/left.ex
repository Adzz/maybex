defmodule Left do
  @enforce_keys [:value]
  defstruct [:value]

  def new(value) do
    %Left{value: value}
  end

  def map(%Left{value: value}, _function) do
    Left.new(value)
  end

  def fold(%Left{value: value}, left_function, _right_function \\ fn(x) -> x end) do
    left_function.(value)
  end
end
