defmodule Containers.OptionalTest do
  use ExUnit.Case, async: true
  import Containers
  alias Containers.Text
  alias Containers.Optional

  doctest Containers.Optional

  setup_all do
    hello = Text.from_string("Hello")
    world = Text.from_string(" world!")

    {:ok, %{hello_opt: Optional.to_optional(hello),
            world_opt: Optional.to_optional(world),
            nil_opt: Optional.to_optional(nil)}
    }
  end

  test "implements Appendable", %{hello_opt: hello_opt, world_opt: world_opt, nil_opt: nil_opt} do
    assert %Optional{value: %Text{value: "Hello"}} = Containers.append(hello_opt, nil_opt)
    assert %Optional{value: %Text{value: "Hello"}} = Containers.append(nil_opt, hello_opt)
    assert %Optional{value: %Text{value: "Hello world!"}} = Containers.append(hello_opt, world_opt)
  end

  test "implements Mappable", %{hello_opt: hello_opt, nil_opt: nil_opt} do
    assert %Optional{value: nil} = Containers.map(nil_opt, fn(%Text{value: t}) -> t <> "!" end)
    assert %Optional{value: "Hello!"} = Containers.map(hello_opt, fn(%Text{value: t}) -> t <> "!" end)
  end

  test "implements Sequenceable", %{hello_opt: hello_opt, nil_opt: nil_opt} do
    sequenced =
      hello_opt >>> fn(_) -> Optional.to_optional(123) end
                >>> fn(n) -> Optional.to_optional(n * n) end

    nil_seq =
      nil_opt >>> fn(%Text{} = t) -> t |> Containers.safe_unwrap(t, "bob") |> Optional.to_optional() end

    assert %Optional{value: nil} = nil_seq
    assert %Optional{value: 15129} = sequenced
  end

  test "implements Flattenable protocol correctly" do
    nested_nil_value = %Optional{value: %Optional{value: nil}}
    nested_value = %Optional{value: %Optional{value: 1}}

    assert Containers.flatten(nested_nil_value) == %Optional{value: nil}
    assert Containers.flatten(nested_value) == %Optional{value: 1}
  end
end
