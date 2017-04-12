defmodule Containers.Result do
  @moduledoc """
  This container is useful when you want to do chainable maps or sequences on the `:ok` `:error` tuple
  pattern that Elixir uses for actions that could fail.

  # Implemented Protocols

    1. Mappable
    2. Sequenceable
    3. Unwrappable

  """
  alias __MODULE__

  @typedoc """
  A tuple that follows the `{:ok, value}` or `{:error, value}` pattern
  """
  @type result_tuple :: {:ok, any()} | {:error, any()}
  @type t :: %Result{value: result_tuple}

  defstruct value: {:ok, nil}

  @doc """
  Takes a normal tuple of either `{:ok, value}` or `{:error, value}` and
  turns it into the Result Container.

  Will throw `NoMatch` error if something other then `result_tuple` is
  passed in.

  ## Examples

      iex> Containers.Result.from_tuple({:ok, "hello"})
      %Containers.Result{value: {:ok, "hello"}}

      iex> Containers.Result.from_tuple({:error, "no"})
      %Containers.Result{value: {:error, "no"}}
  """
  @spec from_tuple(result_tuple) :: t()
  def from_tuple({:ok, _} = t), do: %Result{value: t}
  def from_tuple({:error, _} = t), do: %Result{value: t}
end

defimpl Containers.Mappable, for: Containers.Result do
  def map(%Containers.Result{value: {:ok, value}}, f),
    do: %Containers.Result{value: {:ok, f.(value)}}
  def map(%Containers.Result{value: {:error, _} = r}, _f),
    do: %Containers.Result{value: r}
  def map(%Containers.Result{} = r, _f), do: r
end

defimpl Containers.Sequenceable, for: Containers.Result do
  def next(%Containers.Result{value: {:ok, v}}, f),
    do: f.(v)
  def next(%Containers.Result{value: {:error, _} = r}, _f),
    do: r
end

defimpl Containers.Unwrappable, for: Containers.Result do
  def safe(%Containers.Result{value: {:ok, nil}}, default),
    do: {:ok, default}
  def safe(%Containers.Result{value: {:ok, _v} = r}, _default),
    do: r

  def safe(%Containers.Result{value: {:error, nil}}, default),
    do: {:error, default}
  def safe(%Containers.Result{value: {:error, _} = r}),
    do: r

  def unsafe!(%Containers.Result{value: r}), do: r
end
