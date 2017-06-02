defprotocol Containers.Flattenable do
  @spec flatten(Containers.flattenable)
  :: Containers.flattenable
  def flatten(flattable)
end
