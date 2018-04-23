defprotocol Maybe do
  def map(left_or_right, function)
  def fold(left_or_right, left_function, right_function)
  # this is because the fold's right function has a default arg - the id function
  def fold(left_or_right, left_function)
  def safe_pipe(left_or_right, left_function, right_function)
end
