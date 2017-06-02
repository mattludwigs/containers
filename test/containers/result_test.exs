defmodule Containers.ResultTest do
  use ExUnit.Case, async: true

  import Containers, only: [>>>: 2]
  alias Containers.Result
  alias Containers.Text
  alias Containers.Optional
  doctest Containers.Result

  setup_all do
    {:ok, %{ok_result: Result.to_result({:ok, "hello"}),
            error_result: Result.to_result({:error, "sad"}),
            ok_value_result: Result.to_result(:ok),
            error_value_result: Result.to_result(:error)
           }}
  end

  test "implements Mappable protocol",
  %{ok_result: ok_result, error_result: error_result, ok_value_result: ok_vr, error_value_result: error_vr} do
    assert %Containers.Result{value: {:ok, "hello!"}} = Containers.map(ok_result, fn(hello) -> hello <> "!" end)
    assert %Containers.Result{value: {:error, "sad"}} = Containers.map(error_result, fn(sad) -> sad <> "!" end)
    assert %Containers.Result{value: {:ok, 3}} = Containers.map(ok_vr, fn(_) -> 2 + 1 end)
    assert %Containers.Result{value: :error} = Containers.map(error_vr, fn(does_not_matter) -> does_not_matter + 1 end)
  end

  test "joins when inner structure is {:ok, {:ok, value}}" do
    r =
      {:ok, {:ok, 10}}
      |> Result.to_result()

    assert Result.join(r) == %Result{value: {:ok, 10}}
  end

  test "joins when inner structure is {:ok, :ok}" do
    r =
      {:ok, :ok}
      |> Result.to_result()

    assert Result.join(r) == %Result{value: :ok}
  end

  test "join handles {:ok {:error, v}}" do
    r =
      {:ok, {:error, 10}}
      |> Result.to_result()

    assert Result.join(r) == %Result{value: {:error, 10}}
  end

  test "join with ignore if first result has :error" do
    r =
      {:error, {:ok, "blah"}}
      |> Result.to_result()

    assert Result.join(r) == r
  end

  test "implements the Flattenable protocol correctly for inner value of {:ok, result}" do
    nested_ok_tuples = %Result{value: {:ok, Result.to_result({:ok, 1})}}
    assert Containers.flatten(nested_ok_tuples) == Result.to_result({:ok, 1})
  end

  test "implements the Flattenable protocol correctly for inner value of result" do
    assert Containers.flatten(%Result{value: Result.to_result(:ok)}) == Result.to_result(:ok)
    assert Containers.flatten(%Result{value: Result.to_result(:error)}) == Result.to_result(:error)
  end

  test "implements the Flattenable protocol correctly for inner vlaue of {:error, result}" do
    nested_error = %Result{value: {:error, Result.to_result(:ok)}}
    assert Containers.flatten(nested_error) == nested_error
  end

  test "implements Sequenceable protocol", %{ok_result: ok_result, ok_value_result: ok_vr} do
    sequenced =
      ok_result >>> fn(hello) -> Text.from_string(hello <> "!!") end
                >>> fn(s) -> s |> Optional.to_optional() end

    atom_sequenced =
      ok_vr >>> fn(ok_atom) -> ok_atom |> Atom.to_string() |> Text.from_string() end
            >>> fn(ok_str) -> Text.from_string(ok_str <> "!") end

    assert %Containers.Optional{value: "hello!!"} = sequenced
    assert %Containers.Text{value: "ok!"} = atom_sequenced
  end
end
