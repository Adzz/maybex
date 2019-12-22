defimpl Maybe, for: Tuple do
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

  def is_error?({:ok, _}), do: false
  def is_error?({:error, _}), do: true
  def is_error?(t), do: error(t)

  def is_ok?({:ok, _}), do: true
  def is_ok?({:error, _}), do: false
  def is_ok?(t), do: error(t)

  defp error(t) do
    raise("Tuple must be in the form {:ok, result} | {:error, error} got #{inspect(t)}")
  end
end

# Both these are now possible. Which is fun. You could also implement it for a list yourself... Much better!
# {:ok, 10} |> Maybe.map(fn x -> x * 10 end) |> Maybe.map(fn x -> x + 2 end)
# Result.lift(10)  |> Maybe.map(fn x -> x * 10 end)  |> Maybe.map(fn x -> x + 2 end)
#
