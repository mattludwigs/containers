defmodule Containers.Classy.List do
  @moduledoc """
  Provide total function support to the `List` function in the
  standard Elixir library.
  """
  alias Containers.Optional

  @doc """
  Safetly wraps the Elixir.List.first function to return if an Optional
  to protect against runtime failure.

  ## Examples

      iex> Containers.Classy.List.first []
      %Containers.Optional{value: nil}
      iex> Containers.Classy.List.first [1]
      %Containers.Optional{value: 1}
  """
  @spec first(list) :: Optional.t
  def first([]), do:  Optional.to_optional(nil)
  def first(list) do
    list |> List.first() |> Optional.to_optional()
  end
end

defimpl Containers.Mappable, for: List do
  def map([], _f), do: []
  def map(list, f), do: Enum.map(list, f)
end
