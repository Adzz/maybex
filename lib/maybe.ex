defprotocol Maybe do
  def map(left_or_right, function)
  def fold(left_or_right, left_function, right_function)
  # this is because the fold's right function has a default arg - the id function
  def fold(left_or_right, left_function)
  def safe_pipe(left_or_right, left_function, right_function)
end

defimpl Maybe, for: Left do
  defdelegate map(left, function), to: Left
  defdelegate fold(left, left_function, right_function \\ fn(x) -> x end), to: Left

  def safe_pipe(%Left{value: value}, left_function, _right_function) do
    Either.new(left_function.(value))
  end
end

defimpl Maybe, for: Right do
  defdelegate map(right, function), to: Right
  defdelegate fold(right, left_branch, right_branch \\ fn(x) -> x end), to: Right

  def safe_pipe(%Right{value: value}, _left_function, right_function) do
    Either.new(right_function.(value))
  end
end

