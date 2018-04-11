defprotocol Containers.Sequenceable do
  @moduledoc """
  provides `and_then` function to chain compuations together

  If a custome structure implements a field `value` in the struct,
  then that structe can derive `Sequenceable`.
  """

  @doc """
  `struct` argument is some sturct that implements `Sequenceable`

  `f` is a function that takes in the inner value potentially does something
  to the inner value and wraps it back up in a struct
  """
  @spec and_then(Containers.sequenceable(), (any() -> Containers.sequenceable())) ::
          Containers.sequenceable()
  def and_then(struct, f)
end

defimpl Containers.Sequenceable, for: Any do
  def and_then(%{value: value}, f), do: f.(value)
end
