defmodule Containers.Result do
  @moduledoc """
  This container is useful when you want to do chainable maps or sequences on the `:ok` `:error` tuple
  pattern that Elixir uses for actions that could fail.

  # Implemented Protocols

    1. Mappable
    2. Sequenceable
    3. Unwrappable
    4. Flattenable

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

  @doc """
  join is usefull when you have a inner value of something like
  `{:ok, {:ok, value}}` and you want make the inner value `{:ok, value}`

  ## Examples

      iex> outter = Containers.Result.to_result({:ok, {:ok, 1}})
      %Containers.Result{value: {:ok, {:ok, 1}}}
      iex> Containers.Result.join(outter)
      %Containers.Result{value: {:ok, 1}}
  """
  @spec join(t) :: t
  def join(%Result{value: {:ok, {type, _value} = inner}})
      when type in [:error, :ok],
      do: to_result(inner)

  def join(%Result{value: {:ok, :ok}}), do: to_result(:ok)
  def join(%Result{value: {:error, _value}} = r), do: r
end

defimpl Containers.Mappable, for: Containers.Result do
  alias Containers.Result

  def map(%Result{value: {:ok, value}}, f), do: %Result{value: {:ok, f.(value)}}
  def map(%Result{value: {:error, _} = r}, _f), do: %Result{value: r}
  def map(%Result{value: :ok = v}, f), do: %Result{value: {:ok, f.(v)}}
  def map(%Result{} = r, _f), do: r
end

defimpl Containers.Sequenceable, for: Containers.Result do
  alias Containers.Result

  def and_then(%Result{value: {:ok, v}}, f), do: f.(v)
  def and_then(%Result{value: {:error, _} = r}, _f), do: r
  def and_then(%Result{value: :ok = v}, f), do: f.(v)
  def and_then(%Result{value: :error = e}, _f), do: e
end

defimpl Containers.Unwrappable, for: Containers.Result do
  alias Containers.Result
  def safe(%Result{value: {:ok, nil}}, default), do: {:ok, default}
  def safe(%Result{value: {:ok, _v} = r}, _default), do: r

  def safe(%Result{value: {:error, nil}}, default), do: {:error, default}
  def safe(%Result{value: {:error, _} = r}, _default), do: r

  def safe(%Result{value: v}, _default) when v in [:ok, :error], do: v

  def unsafe!(%Result{value: r}), do: r
end

defimpl Containers.Joinable, for: Containers.Result do
  alias Containers.Result

  def join(%Result{value: {:ok, %Result{} = inner}}), do: inner

  def join(%Result{value: %Result{value: v} = inner})
      when v in [:error, :ok],
      do: inner

  def join(%Result{value: {:error, %Result{}}} = r), do: r
end
