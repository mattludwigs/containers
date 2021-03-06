defmodule Containers.Classy.Integer do
  @moduledoc """
  Provide total function support for `Integer` in the
  Elixir standard library.
  """

  alias Containers.Result

  @doc """
  Wraps the Elxir `Integer.parse` function and returns
  `Result` container.

  ## Examples

      iex> Containers.Classy.Integer.parse "34"
      %Containers.Result{value: {:ok, {34, ""}}}

      iex> Containers.Classy.Integer.parse "34.5"
      %Containers.Result{value: {:ok, {34, ".5"}}}

      iex> Containers.Classy.Integer.parse "three"
      %Containers.Result{value: {:error, :no_parse}}

      iex> Containers.Classy.Integer.parse "a2", 38
      %Containers.Result{value: {:error, "invalid base 38"}}

  """
  @spec parse(String.t(), integer()) :: Result.t()
  def parse(binary, base \\ 10) do
    try do
      case Integer.parse(binary, base) do
        :error -> {:error, :no_parse} |> Result.to_result()
        result -> {:ok, result} |> Result.to_result()
      end
    rescue
      e -> {:error, e.message} |> Result.to_result()
    end
  end
end
