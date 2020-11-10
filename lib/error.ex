defmodule Maybe.Error do
  defstruct [:value]

  defimpl Maybe do
    def map(error, _fun), do: error
    def map_error(%{value: value}, fun), do: Result.lift(%Maybe.Error{}, fun.(value))
    def unwrap!(%{value: value}), do: raise("Error: #{value}")
    def unwrap(%{value: value}), do: value
    def unwrap_or_else(%{value: value}, fun), do: fun.(value)
    def is_error?(_), do: true
    def is_ok?(_), do: false
  end
end
