defmodule Containers.TextTest do
  use ExUnit.Case, async: true

  alias Containers.Text
  doctest Containers.Text

  setup_all do
    {:ok, %{hello: Text.from_string("hello"),
             world: Text.from_string(" world!"),
             nil_string: Text.from_string(nil)}
     }
  end

  test "implements Appendable protocol", %{hello: hello, world: world, nil_string: nil_string} do
    assert %Text{value: "hello world!"} = Containers.append(hello, world)
    assert %Text{value: "hello"} = Containers.append(hello, nil_string)
    assert %Text{value: "hello"} = Containers.append(nil_string, hello)
  end

  test "implements Mappable protocol", %{hello: hello, nil_string: nil_string} do
    assert %Text{value: "HELLO"} = Containers.map(hello, &String.upcase/1)
    assert %Text{value: nil} = Containers.map(nil_string, &String.upcase/1)
  end

  test "implements Unwrappable protocol", %{hello: hello, nil_string: nil_string} do
    assert nil == Containers.unsafe_unwrap(nil_string)
    assert "hello" == Containers.unsafe_unwrap(hello)
    assert "hello" == Containers.safe_unwrap(hello, "world")
    assert "world" == Containers.safe_unwrap(nil_string, "world")
  end
end
