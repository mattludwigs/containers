defmodule Containers.Classy.List.Test do
  use ExUnit.Case, async: true

  alias Containers.Optional
  alias Containers.Classy.List, as: ClassyList

  doctest ClassyList

  test "wraps List.first/1 return in an Optional" do
    assert ClassyList.first([]) == %Optional{value: nil}
  end

  test "Wraps the Elixr.List module when list is not empty returing an Optional" do
    assert ClassyList.first([1, 2]) == %Optional{value: 1}
  end
end
