defmodule Containers.Text do
  @moduledoc """
  This container wraps a string value. This is useful for when you want to append strings
  together with not wanting to worry about `nil` throwing runtime errors.

  # Implemented Protocols

    1. Appenedable
    2. Mappable
    3. Unwrappable
    4. Sequenceable
  """
  alias __MODULE__

  @type t() :: %Text{value: String.t()}

  @derive [Containers.Unwrappable, Containers.Sequenceable]
  defstruct [value: ""]

  @doc """
  takes a normal string and puts in a Text Container.

  ## Examples

      iex> Containers.Text.from_string("hello world")
      %Containers.Text{value: "hello world"}
  """
  @spec from_string(String.t()) :: t()
  def from_string(str), do: %Text{value: str}
end

defimpl Containers.Appenedable, for: Containers.Text do
  def append(%Containers.Text{value: nil}, s), do: s
  def append(s, %Containers.Text{value: nil}), do: s
  def append(%Containers.Text{value: s1}, %Containers.Text{value: s2}), do: %Containers.Text{value: s1 <> s2}
end

defimpl Containers.Mappable, for: Containers.Text do
  def map(%Containers.Text{value: nil} = s, _f), do: s
  def map(%Containers.Text{value: v}, f) do
    v
    |> String.split("", trim: true)
    |> Enum.map(fn s -> f.(s) end)
    |> Enum.join("")
    |> Containers.Text.from_string
  end
end
