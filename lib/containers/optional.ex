defmodule Containers.Optional do
  @moduledoc """
  Inspired by the Maybe type in other languages this container provides a way
  to wrap any value and safely transform the value. This should result in
  less runtime errors.

  # Implemented Protocols

    1. Appendable
    2. Mappable
    3. Sequenceable
    4. Unwrappable
    5. Joinable

  **NOTE** Appendable assumes that the inner value implements the Appendable protocol. Until further research is done
  there does not seem to be a way to ensure this is true of the inner value at compile time.

  """
  alias __MODULE__

  @type t :: %Optional{value: any}

  @derive [Containers.Unwrappable]
  defstruct value: nil

  @doc """
  Takes any value and puts it in the `Optional` container.

  ## Examples

      iex> Containers.Optional.to_optional(1)
      %Containers.Optional{value: 1}
  """

  @spec to_optional(any()) :: t()
  def to_optional(v), do: %Optional{value: v}
end

defimpl Containers.Appendable, for: Containers.Optional do
  alias Containers.Optional
  def append(%Optional{value: nil}, o), do: o
  def append(o, %Optional{value: nil}), do: o
  def append(%Optional{value: v1}, %Optional{value: v2}),
    do: %Optional{value: Containers.append(v1, v2)}
end

defimpl Containers.Mappable, for: Containers.Optional do
  alias Containers.Optional
  def map(%Optional{value: nil} = o, _f), do: o
  def map(%Optional{value: v}, f), do: %Containers.Optional{value: f.(v)}
end

defimpl Containers.Sequenceable, for: Containers.Optional do
  alias Containers.Optional
  def and_then(%Optional{value: nil} = o, _f), do: o
  def and_then(%Optional{value: v}, f), do: f.(v)
end

defimpl Containers.Joinable, for: Containers.Optional do
  alias Containers.Optional
  def join(%Optional{value: %Optional{value: value}}), do: Optional.to_optional(value)
end
