# Could we implement all these here? https://doc.rust-lang.org/std/result/enum.Result.html#method.unwrap_or_else
defprotocol Maybe do
  @doc """
  Applies fun to the value inside an Ok, returning the result lifted into an Ok. Returns an Error
  untouched if passed one
  """
  def map(thing, fun)
  @doc "Like map, but works on the error only. If passed an Ok, passes it through untouched"
  def map_error(thing, fun)
  @doc "Returns the value contained inside the thing, raising if the thing is an error"
  def unwrap!(thing)
  @doc "Returns the value contained inside the thing, regardless of whether it is an error or not"
  def unwrap(thing)

  @doc """
  Returns the value inside the Ok if passed an Ok, or passes the value inside the Error to the
  or_else fun and calls it
  """
  def unwrap_or_else(thing, or_else)
  @doc "Returns true if the thing is an Error, false otherwise"
  def is_error?(thing)
  @doc "Returns true if the thing is not an error, false otherwise"
  def is_ok?(thing)
  # We should make it so that the protocol itself can be extended by the users of the library.
end
