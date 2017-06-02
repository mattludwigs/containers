defmodule Containers.Text do
  @moduledoc """
  This container wraps a string value. This is useful for when you want to append strings
  together with not wanting to worry about `nil` throwing runtime errors.

  # Implemented Protocols

    1. Appendable
    2. Mappable
    3. Unwrappable
    4. Sequenceable
  """
  alias __MODULE__
  alias Containers.Optional
  alias Containers.Result

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

  @doc """
  Wraps the `String.to_atom` function but returns a `Result` container
  if it unable to parse string into an atom.

  ## Examples

      iex> hello = "hello" |> Containers.Text.from_string()
      iex> Containers.Text.to_atom(hello)
      %Containers.Result{value: {:ok, :hello}}
  """
  @spec to_atom(t) :: Result.t
  def to_atom(%Text{value: s}) do
    try do
      {:ok, String.to_atom(s)}
      |> Result.to_result()
    rescue
      e -> {:error, e} |> Result.to_result()
    end
  end

  @doc """
  Wraps the `String.to_integer` function but will return a `Result` Conainer

  ## Examples

      iex> one = "1" |> Containers.Text.from_string()
      iex> Containers.Text.to_integer(one)
      %Containers.Result{value: {:ok, 1}}
  """
  @spec to_integer(t) :: Result.t
  def to_integer(%Text{value: s}) do
    try do
      {:ok, String.to_integer(s)}
      |> Result.to_result()
    rescue
      e -> {:error, e} |> Result.to_result()
    end
  end

  @doc """
  Wraps the `String.at` function in Elixir to return an optional

  ## Examples

      iex> hello = Containers.Text.from_string("hello")
      iex> Containers.Text.at(hello, 0)
      %Containers.Optional{value: %Containers.Text{value: "h"}}

  ## Advanced Example

  In below example `at` returns an `Optional`, and since `Optional`
  implements a `Mappable` we can map over the in inner value and append
  another `Text` value to the inner `Text` value. This is safely done
  because if the `Option` value is nil it will skip the appending.

  Plus, the code does not need to break the pipe to handle `nil` cases.

  ```
  some_string
  |> Text.from_string()
  |> Text.at(0)
  |> Containers.map(& Containers.append(&1, Text.from_string("!")))
  ```
  """
  @spec at(t, integer()) :: Optional.t
  def at(%Text{value: s}, n) do
    case String.at(s, n) do
      nil -> Optional.to_optional(nil)
      s -> s |> Text.from_string() |> Optional.to_optional()
    end
  end

  @doc """
  Wraps the `String.first` function in Elixir to reutrn an optional. This will
  allow the `Optional` container protocols to be called

  ## Examples

      iex> hello = Containers.Text.from_string("hello")
      iex> Containers.Text.first(hello)
      %Containers.Optional{value: %Containers.Text{value: "h"}}
  """
  @spec first(t) :: Optional.t
  def first(%Text{value: s}) do
    case String.first(s) do
      nil -> Optional.to_optional(nil)
      s -> s |> Text.from_string() |> Optional.to_optional()
    end
  end

  @doc """
  Wraps the `String.myer_difference` function in Elixir to return an Optional.

  ## Examples

      iex> string1 = Containers.Text.from_string("fox hops over the dog")
      iex> string2 = Containers.Text.from_string("fox jumps over the lazy cat")
      iex> Containers.Text.myers_difference(string1, string2)
      %Containers.Optional{value: [eq: "fox ", del: "ho", ins: "jum", eq: "ps over the ", del: "dog", ins: "lazy cat"]}
  """
  @spec myers_difference(t, t) :: Optional.t()
  def myers_difference(%Text{value: s1}, %Text{value: s2}) do
    String.myers_difference(s1, s2) |> Optional.to_optional()
  end

  @doc """
  Wraps the `String.next_codepiont` function in Elixir to return an Optional.
  """
  @spec next_codepoint(t) :: Optional.t()
  def next_codepoint(%Text{value: s}) do
    case String.next_codepoint(s) do
      nil -> Optional.to_optional(nil)
      result -> Optional.to_optional(result)
    end
  end

  @doc """
  Wraps the `String.get_grapheme` function in Elixir to return an Optional.
  """
  @spec next_grapheme(t) :: Optional.t()
  def next_grapheme(%Text{value: s}) do
    case String.next_grapheme(s) do
      nil -> Optional.to_optional(nil)
      result -> Optional.to_optional(result)
    end
  end
end

defimpl Containers.Appendable, for: Containers.Text do
  alias Containers.Text
  def append(%Text{value: nil}, s), do: s
  def append(s, %Text{value: nil}), do: s
  def append(%Text{value: s1}, %Text{value: s2}), do: %Text{value: s1 <> s2}
end

defimpl Containers.Mappable, for: Containers.Text do
  alias Containers.Text
  def map(%Text{value: nil} = s, _f), do: s
  def map(%Text{value: v}, f) do
    v
    |> String.split("", trim: true)
    |> Enum.map(fn s -> f.(s) end)
    |> Enum.join("")
    |> Text.from_string
  end
end
