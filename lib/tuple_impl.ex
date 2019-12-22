defimpl Maybe, for: Tuple do
  def map({:ok, stuff}, fun) do
    Result.lift({:ok}, fun.(stuff))
  end

  def map({:error, stuff}, _fun) do
    {:error, stuff}
  end

  def map(t, _), do: raise("Tuple must be in the form {:ok, result} | {:error, error} got #{t}")

  # def map_error({:ok, thing}, _fun) do
  #   {:ok, thing}
  # end

  # def map_error({:error, thing}, fun) do
  # end

  # def unwrap!(%{value: value}), do: value
  # def unwrap(%{value: value}), do: value
  # def unwrap_or_else(%{value: value}, _fun), do: value
  # def is_error?(_), do: false
  # def is_ok?(_), do: true
end

# Both these are now possible. Which is fun. You could also implement it for a list yourself... Much better!
# {:ok, 10} |> Maybe.map(fn x -> x * 10 end) |> Maybe.map(fn x -> x + 2 end)
# Result.lift(10)  |> Maybe.map(fn x -> x * 10 end)  |> Maybe.map(fn x -> x + 2 end)
#
