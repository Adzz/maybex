defprotocol Result do
  def lift(thing, value)
  # Anything not a left is a right.
  def is_left?(thing)
end

defimpl Result, for: Ok do
  def lift(_, value) do
    if Result.impl_for(value) do
      if Result.is_left?(value) do
        value
      else
        if Maybe.impl_for(value) do
          %Ok{value: Maybe.unwrap(value)}
        else
          %Ok{value: value}
          # raise(Protocol.UndefinedError,
          #   protocol: Maybe,
          #   value: value,
          #   description: "Result has been implemented, but Maybe has not"
          # )
        end
      end
    else
      # If it's not a left or a right it can be put in either safely.
      %Ok{value: value}
    end
  end

  def is_left?(_), do: false
end

defimpl Result, for: Error do
  def lift(_, value) do
    if Result.impl_for(value) do
      if Result.is_left?(value) do
        if Maybe.impl_for(value) do
          %Error{value: Maybe.unwrap(value)}
        else
          %Error{value: value}
          # raise(Protocol.UndefinedError,
          #   protocol: Maybe,
          #   value: value,
          #   description: "Result has been implemented, but Maybe has not"
          # )
        end
      else
        value
      end
    else
      %Error{value: value}
    end
  end

  def is_left?(_), do: true
end

defimpl Result, for: Tuple do
  def lift({:ok}, value) do
    if Result.impl_for(value) do
      # This means we have a thing we can 'lift'
      if Result.is_left?(value) do
        # This means we the value is "correct", and therefore we can pass it through.
        # We can think about it after
        value
      else
        if Maybe.impl_for(value) do
          {:ok, Maybe.unwrap(value)}
        else
          # raise(Protocol.UndefinedError,
          #   protocol: Maybe,
          #   value: value,
          #   description: "Result has been implemented, but Maybe has not"
          # )
          {:ok, value}
        end
      end
    else
      {:ok, value}
    end
  end

  def lift({:error}, value) do
    if Result.impl_for(value) do
      if Result.is_left?(value) do
        # is an Error
        if Maybe.impl_for(value) do
          # Now we know we want to unwrap it from the right it is in, and put it in our
          # right
          {:error, Maybe.unwrap(value)}
        else
          {:error, value}
          # We shouldn't implement lift and not implement maybe I think.
          # raise(Protocol.UndefinedError,
          #   protocol: Maybe,
          #   value: value,
          #   description: "Result has been implemented, but Maybe has not. "
          # )
        end
      else
        value
      end
    else
      {:error, value}
    end
  end

  def is_left?({:ok, _}), do: false
  def is_left?({:error, _}), do: true
end

# %Ok{value: 10} |> Maybe.map(fn x -> x * 10 end) |> Maybe.map(fn _x -> %Error{value: "Nope!"} end) |> Maybe.map(fn x -> x * 10 end)
# %Error{value: "Nope!"}

# %Ok{value: 10} |> Maybe.map(fn x -> x * 10 end) |> Maybe.map(fn _x -> {:error, "Nope!"} end) |> Maybe.map(fn x -> x * 10 end)

# {:error, "Nope!"}

# %Ok{value: 10} |> Maybe.map(fn x -> x * 10 end) |> Maybe.map(fn x -> {:ok, x} end) |> Maybe.map(fn x -> %Error{value: 10} end)
# {:ok, 1000}
