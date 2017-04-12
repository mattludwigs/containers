defprotocol Containers.Unwrappable do
  def safe(struct, default)
  def unsafe!(struct)
end

defimpl Containers.Unwrappable, for: Any do
  def safe(%{value: nil}, default), do: default
  def safe(%{value: v}, _default), do: v

  def unsafe!(%{value: v}), do: v
end
