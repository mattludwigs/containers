defprotocol Containers.Joinable do
  @moduledoc """
  Protocol for joining nested container structures by exposing the `join` function
  """
  @spec join(Containers.Joinable) :: Containers.Joinable
  def join(joinable)
end
