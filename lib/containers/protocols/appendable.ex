defprotocol Containers.Appendable do
  @moduledoc """
  Protocol for appending things by exposing the `append` function
  """

  @doc """
  Append takes two of the same Appendable value and puts them together. Returning
  a new struct with the appended value.
  """
  @spec append(Containers.appendable(), Containers.appendable()) :: Containers.appendable()
  def append(v1, v2)
end
