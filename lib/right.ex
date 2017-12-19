defmodule Right do
  @enforce_keys [:value]
  defstruct [:value]

  def new(value) do
    %Right{value: value}
  end

  def map(%Right{value: value}, func) do
    Right.new(func.(value))
  end

  def fold(%Right{value: value}, _left_function, right_function \\ fn(x) -> x end) do
    right_function.(value)
  end
end


