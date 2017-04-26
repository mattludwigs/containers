defmodule Containers.Int do
  @moduledoc """
  Provides functions for interacting with the Integer primitive
  using containers.
  """

  alias Containers.Result

  @doc """
  Wraps the Elxir `Integer.parse` function and returns
  `Result` container.

  ## Examples

      iex> Containers.Int.parse "34"
      %Containers.Result{value: {:ok, {34, ""}}}

      iex> Containers.Int.parse "34.5"
      %Containers.Result{value: {:ok, {34, ".5"}}}

      iex> Containers.Int.parse "three"
      %Containers.Result{value: {:error, :no_parse}}

      iex> Containers.Int.parse "a2", 38
      %Containers.Result{value: {:error, "invalid base 38"}}

  """
  @spec parse(String.t, integer()) :: Result.t()
  def parse(binary, base \\ 10) do
    try do
      case Integer.parse(binary, base) do
        :error -> {:error, :no_parse} |> Result.from_tuple()
        result -> {:ok, result} |> Result.from_tuple()
      end
    rescue
      e -> {:error, e.message} |> Result.from_tuple()
    end
  end
end
