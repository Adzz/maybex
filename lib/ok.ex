defmodule Maybe.Ok do
  defstruct [:value]

  defimpl Maybe do
    def map(%{value: value}, fun), do: Result.lift(%Maybe.Ok{}, fun.(value))
    def map_error(ok, _fun), do: ok
    def unwrap!(%{value: value}), do: value
    def unwrap(%{value: value}), do: value
    def unwrap_or_else(%{value: value}, _fun), do: value
    def is_error?(_), do: false
    def is_ok?(_), do: true
  end
end
