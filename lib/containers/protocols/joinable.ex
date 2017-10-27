defprotocol Containers.Joinable do
  @moduledoc """
  Protocol for flattening container structures by exposing the `flatten` function
  """
  @spec join(Containers.Joinable)
  :: Containers.Joinable
  def join(joinable)
end
