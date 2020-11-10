defprotocol Result do
  def lift(thing, value)
  # Anything not a left is a right.
  def is_left?(thing)
end

defimpl Result, for: Maybe.Ok do
  def lift(_, value) do
    if Result.impl_for(value) do
      if Result.is_left?(value) do
        value
      else
        if Maybe.impl_for(value) do
          value
        else
          %Maybe.Ok{value: value}
          # raise(Protocol.UndefinedError,
          #   protocol: Maybe,
          #   value: value,
          #   description: "Result has been implemented, but Maybe has not"
          # )
        end
      end
    else
      # If it's not a left or a right it can be put in either safely.
      %Maybe.Ok{value: value}
    end
  end

  def is_left?(_), do: false
end

defimpl Result, for: Maybe.Error do
  def lift(_, value) do
    if Result.impl_for(value) do
      if Result.is_left?(value) do
        if Maybe.impl_for(value) do
          value
        else
          %Maybe.Error{value: value}
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
      %Maybe.Error{value: value}
    end
  end

  def is_left?(_), do: true
end

defimpl Result, for: Tuple do
  def lift({:ok}, value) do
    if Result.impl_for(value) do
      # This means we have a thing we can 'lift'
      if Result.is_left?(value) do
        # is error...
        value
      else
        if Maybe.impl_for(value) do
          value
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
          value
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

  def lift(t, _) do
    raise(
      "Tuple type not supported, you can only lift into an {:ok} or an {:error}, " <>
        " got #{inspect(t)}. If you have a value you wish to lift into an error do this:\n" <>
        "Result.lift({:error}, :thing)\n\n If you have a value you wish to lift into an okay tuple " <>
        "do this:\n Result.lift({:ok}, :thing)\n\n"
    )
  end

  def is_left?({:ok, _}), do: false
  def is_left?({:error, _}), do: true

  def is_left?(t) do
    raise("Tuple must be in the form {:ok, result} | {:error, error} got #{inspect(t)}")
  end
end
