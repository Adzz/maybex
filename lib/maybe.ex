defprotocol Maybe do
  def map(left_or_right, function)
  def fold(left_or_right, left_function, right_function)
  # this is because the fold's right function has a default arg - the id function
  def fold(left_or_right, left_function)
end

defimpl Maybe, for: Left do
  def map(%Left{value: value}, _function) do
    Left.new(value)
  end

  def fold(%Left{value: value}, left_function, _right_function \\ fn(x) -> x end) do
    left_function.(value)
  end
end

defimpl Maybe, for: Right do
  def map(%Right{value: value}, func) do
    Right.new(func.(value))
  end

  def fold(%Right{value: value}, _left_function, right_function \\ fn(x) -> x end) do
    right_function.(value)
  end
end

