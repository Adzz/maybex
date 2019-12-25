defprotocol Maybe do
  @doc """
  Applies fun to the value inside an Ok, returning the result lifted into an Ok. Returns an Error
  untouched if passed one

  ### Examples

      iex> {:ok, 10} |> Maybe.map(fn x -> x * 10 end)
      {:ok, 100}

      iex> {:ok, 10} |> Maybe.map(fn x -> {:ok, x * 10} end)
      {:ok, 100}

      iex> {:error, 10} |> Maybe.map(fn x -> x * 10 end)
      {:error, 10}

      iex> {:error, 10} |> Maybe.map(fn x -> {:error, x * 10} end)
      {:error, 10}

      iex> %Error{value: "no"} |> Maybe.map(fn x -> x * 10 end)
      %Error{value: "no"}

      iex> %Ok{value: 10} |> Maybe.map(fn x -> x * 10 end)
      %Ok{value: 100}
  """
  def map(thing, fun)

  @doc """
  Like map, but works on the error only. If passed an ok value, passes it through untouched.

      iex> Maybe.map_error({:error, "Nope"}, fn msg -> msg <> " not at all" end)
      {:error, "Nope not at all"}

      iex> Maybe.map_error({:ok, "Yes"}, fn msg -> msg <> " not at all" end)
      {:ok, "Yes"}

      iex> Maybe.map_error({:error, 10}, fn x -> {:error, x * 10} end)
      {:error, 100}

      iex> Maybe.map_error({:error, 10}, fn _ -> {:ok, "Nope"} end)
      {:ok, "Nope"}
  """
  def map_error(thing, fun)

  @doc """
  Returns the value contained inside the thing, raising if the thing is an error.

      iex> Maybe.unwrap!({:ok, 10})
      10

      iex> Maybe.unwrap!({:error, "Fluffed it"})
      ** (RuntimeError) Error: Fluffed it
  """
  def unwrap!(thing)

  @doc """
  Returns the value contained inside the thing, regardless of whether it is an error or not.

      iex> Maybe.unwrap({:ok, 10})
      10

      iex> Maybe.unwrap({:error, 10})
      10
  """
  def unwrap(thing)

  @doc """
  Returns the value inside the Ok if passed an Ok, or passes the value inside the Error to the
  or_else fun and calls it.

      iex> Maybe.unwrap_or_else({:ok, 10}, fn x -> raise x end)
      10

      iex> Maybe.unwrap_or_else({:error, 10}, fn x -> x + 10 end)
      20
  """
  def unwrap_or_else(thing, or_else)

  @doc """
  Returns true if the thing is an Error, false otherwise.

      iex> Maybe.is_error?({:error, nil})
      true

      iex> Maybe.is_error?({:ok, nil})
      false
  """
  def is_error?(thing)

  @doc """
  Returns true if the thing is not an error, false otherwise.

      iex> Maybe.is_ok?({:error, nil})
      false

      iex> Maybe.is_ok?({:ok, nil})
      true
  """
  def is_ok?(thing)
end
