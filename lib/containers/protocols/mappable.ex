defprotocol Containers.Mappable do
  @moduledoc """
  Protocol for implementing Mappable actios using the `map` function
  """

  @doc """
  Map takes a `Mappable` as `struct` and runs some function `f` on the vlaue, and returns
  the same struct.

  Say you have:

  ```
  an_optional = Containers.Optional.to_optional(1)

  def add_one(n), do: n + 1

  Containers.Mappable.map(an_optional, &add_one/1)

  %Containers.Optional{value: 2}

  ```
  
  """
  @spec map(struct(), (... -> any())) :: struct()
  def map(struct, f)
end
