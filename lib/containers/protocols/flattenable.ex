defprotocol Containers.Flattenable do
  @moduledoc """
  Protocol for flattening container structures by exposing the `flatten` function
  """
  @spec flatten(Containers.flattenable)
  :: Containers.flattenable
  def flatten(flattable)
end
