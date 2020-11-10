defimpl Maybe, for: Tuple do
  # the lift is an attempt to flatten. But how to flatten depends on the thing being flattened.
  def map({:ok, stuff}, fun), do: Result.lift({:ok}, fun.(stuff))
  def map({:error, stuff}, _fun), do: {:error, stuff}
  def map(t, _), do: error(t)

  def map_error({:ok, stuff}, _fun), do: {:ok, stuff}
  def map_error({:error, stuff}, fun), do: Result.lift({:error}, fun.(stuff))
  def map_error(t, _), do: error(t)

  def unwrap!({:ok, value}), do: value
  def unwrap!({:error, value}), do: raise("Error: #{value}")
  def unwrap!(t), do: error(t)

  def unwrap({:ok, value}), do: value
  def unwrap({:error, value}), do: value
  def unwrap(t), do: error(t)

  def unwrap_or_else({:ok, value}, _fun), do: value
  def unwrap_or_else({:error, value}, fun), do: fun.(value)
  def unwrap_or_else(t, _), do: error(t)

  def is_error?(tuple), do: Result.is_left?(tuple)
  def is_ok?(tuple), do: not Result.is_left?(tuple)

  defp error(t) do
    raise("Tuple must be in the form {:ok, result} | {:error, error} got #{inspect(t)}")
  end
end
