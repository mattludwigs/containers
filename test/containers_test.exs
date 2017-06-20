defmodule ContainersTest do
  use ExUnit.Case
  doctest Containers

  alias Containers.Optional

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
