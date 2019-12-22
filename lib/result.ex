defprotocol Result do
  def lift(thing, value)
end

defimpl Result, for: Ok do
  def lift(_, value = %Ok{}), do: value
  def lift(_, error = %Error{}), do: error
  def lift(_, value), do: %Ok{value: value}
end

defimpl Result, for: Error do
  def lift(_, value = %Ok{}), do: value
  def lift(_, error = %Error{}), do: error
  def lift(_, value), do: %Error{value: value}
end

defimpl Result, for: Tuple do
  def lift({:ok}, {:ok, thing}), do: {:ok, thing}
  def lift({:ok}, {:error, thing}), do: {:error, thing}
  def lift({:ok}, thing), do: {:ok, thing}

  def lift({:error}, {:ok, thing}), do: {:ok, thing}
  def lift({:error}, {:error, thing}), do: {:error, thing}
  def lift({:error}, thing), do: {:error, thing}
end
