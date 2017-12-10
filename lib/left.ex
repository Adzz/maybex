defmodule Left do
  @enforce_keys [:value]
  defstruct [:value]

  def new(value) do
    %Left{value: value}
  end
end
