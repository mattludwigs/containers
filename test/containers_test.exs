defmodule ContainersTest do
  use ExUnit.Case
  doctest Containers

  alias Containers.{Optional, Result}

  test "mapn works correctly" do
    mmm = [
      Result.to_result({:ok, Optional.to_optional(2)}),
      Result.to_result({:error, :bad}),
      Result.to_result({:ok, Optional.to_optional(nil)}),
    ]

    assert Containers.mapn(mmm, 3, &(&1 + 1)) ==
      [
        %Result{value: {:ok, %Optional{value: 3}}},
        %Result{value: {:error, :bad}},
        %Result{value: {:ok, %Optional{value: nil}}}, 
      ]
  end

  test "map2 works correctly" do
    mm = [
      Optional.to_optional(nil),
      Optional.to_optional(1),
      Optional.to_optional(12),
    ]

    assert Containers.map2(mm, &(&1 + 1)) ==
      [
        %Optional{value: nil},
        %Optional{value: 2},
        %Optional{value: 13},
      ]
  end
end
