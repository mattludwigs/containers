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
  A tuple that follows the `{:ok, value}`, `{:error, value}`, `:ok`, or `:error` pattern
  """
  @type result_value :: {:ok, any()} | {:error, any()} | :ok | :error
  @type t :: %Result{value: result_value}

  defstruct value: {:ok, nil}

  @doc """
  Takes a value of `:ok`, `:error`, `{:ok, value}`, or `{:error, reason}` and
  truns it into the Result Container

  Will throw `NoMatch` error if something other then `result_value` is
  passed in.

  ## Examples

      iex> Containers.Result.to_result({:ok, "hello"})
      %Containers.Result{value: {:ok, "hello"}}

      iex> Containers.Result.to_result({:error, "no"})
      %Containers.Result{value: {:error, "no"}}

      iex> Containers.Result.to_result(:error)
      %Containers.Result{value: :error}

      iex> Containers.Result.to_result(:ok)
      %Containers.Result{value: :ok}
  """
  @spec to_result(result_value) :: t()
  def to_result(:ok), do: %Result{value: :ok}
  def to_result(:error), do: %Result{value: :error}
  def to_result({:ok, _} = t), do: %Result{value: t}
  def to_result({:error, _} = t), do: %Result{value: t}
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
  def next(%Containers.Result{value: :ok = v}, f),
    do: f.(v)
  def next(%Containers.Result{value: :error = e}, _f),
    do: e
end

defimpl Containers.Unwrappable, for: Containers.Result do
  def safe(%Containers.Result{value: {:ok, nil}}, default),
    do: {:ok, default}
  def safe(%Containers.Result{value: {:ok, _v} = r}, _default),
    do: r

  def safe(%Containers.Result{value: {:error, nil}}, default),
    do: {:error, default}
  def safe(%Containers.Result{value: {:error, _} = r}, _default),
    do: r

  def safe(%Containers.Result{value: v}, _default) when v in [:ok, :error],
    do: v

  def unsafe!(%Containers.Result{value: r}), do: r
end
