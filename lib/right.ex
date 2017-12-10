defmodule Right do
  @enforce_keys [:value]
  defstruct [:value]

  def new(value) do
    %Right{value: value}
  end
end


