defprotocol Containers.Appenedable do
  @moduledoc """
  Protocol for appending things by exposing the `append` function
  """

  @doc """
  Append takes two of same Appenedable value and puts them together. Returning
  a new struct with the appended value.
  """
  @spec append(struct(), struct()) :: struct()
  def append(v1, v2)
end
