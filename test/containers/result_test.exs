defmodule Containers.ResultTest do
  use ExUnit.Case, async: true

  import Containers
  alias Containers.Result
  alias Containers.Text
  alias Containers.Optional
  doctest Containers.Result

  setup_all do
    {:ok, %{ok_result: Result.from_tuple({:ok, "hello"}),
            error_result: Result.from_tuple({:error, "sad"}),
           }}
  end

  test "implements Mappable protocol", %{ok_result: ok_result, error_result: error_result} do
    assert %Containers.Result{value: {:ok, "hello!"}} == Containers.map(ok_result, fn(hello) -> hello <> "!" end)
    assert %Containers.Result{value: {:error, "sad"}} == Containers.map(error_result, fn(sad) -> sad <> "!" end)
  end

  test "implements Sequenceable protocol", %{ok_result: ok_result, error_result: error_result} do
    sequenced =
      ok_result >>> fn(hello) -> Text.from_string(hello <> "!!") end
                >>> fn(s) -> s |> Optional.to_optional() end

    assert %Containers.Optional{value: "hello!!"} = sequenced
  end
end
