defmodule Containers do
  @moduledoc """
  Containers are functional data structures that help provide greater runtime safety and polymorphism.

  ## Protocols

    * `Appendable` - A container that provies an interface of `append`. Safe against `nil` values.
      Namely when passing a container with the value `nil` into either the first of second argument
      to `append`, the other value is not change and there is no runtime error.
    * `Mappable` - A container that provies an interface to `map`. When `map` is called on a container that
      has a `nil` value that container just passes through with out the mapping function being called, and
      this helps prevent runtime errors.
    * `Sequenceable` - A container that provides an interface of `next`. This allows the chaining of computations.
    * `Unwrappable`  - A container that provides an interface to `safe` and `unsafe` unwrapping of inner value. Safe
      will need a default in case of `nil` value of container, helping prevent runtime errors. Unsafe will just return
      the value of the container regardless of a `nil` value potentially causing runtime errors
    * `Flattenable` - A container that provides an interface to `flatten` function. This allows for nested containers of the
       same container type to have the outter layer removed.

  Since these are protocols, and highly decoupled, a developer can implement them as needed on their own structs.
  """

  @type appendable :: Containers.Text.t | Containers.Optional.t
  @type mappable :: Containers.Text.t | Containers.Optional.t | Containers.Result.t
  @type sequenceable :: Containers.Text.t | Containers.Optional.t | Containers.Result.t
  @type unwrappable :: Containers.Text.t | Containers.Optional.t | Containers.Result.t
  @type flattenable :: Containers.Result.t | Containers.Optional.t

  @doc """
  Append two values of the Containers.Appendable protocol

  This is useful for chaning of appending appendable items safely. That is to say if there
  is a `nil` value being used like `nil <> " world!"` there will be a run time error. In this
  case the container for the string type will safe do concatenation.

  ## Examples

      iex> hello = Containers.Text.from_string("Hello")
      iex> world = Containers.Text.from_string(" world!")
      iex> Containers.append(hello, world)
      %Containers.Text{value: "Hello world!"}

      iex> hello = Containers.Text.from_string("Hello")
      iex> world = Containers.Text.from_string(" world!")
      iex> nil_string = Containers.Text.from_string(nil)
      iex> hello |> Containers.append(nil_string) |> Containers.append(world)
      %Containers.Text{value: "Hello world!"}
  """
  @spec append(appendable(), appendable()) :: appendable()
  def append(v1, v2), do: Containers.Appendable.append(v1, v2)

  @doc """
  map some function `f` of the some structure `s`. Works like the `Enum.map` but provides
  more polymorphic protocol, and does rely on the `Enumerable` protocol allowing use of
  just getting map without needing to implement the full `Enumerable` protocol.

  ## Examples

      iex> my_optional = Containers.Optional.to_optional(1)
      iex> Containers.map(my_optional, fn(i) -> i + 1 end)
      %Containers.Optional{value: 2}
  """
  @spec map(mappable, (... -> any())) :: mappable
  def map(s, f), do: Containers.Mappable.map(s, f)

  @doc """
  next is a function that will allow chaining of computations while passing the `value` of the
  last computation.
  """
  @spec next(sequenceable(), (any() -> sequenceable())) :: sequenceable()
  def next(s, f), do: Containers.Sequenceable.next(s, f)

  @doc """
  `>>>` is the infix operator for `next`

  ## Examples

      iex> import Containers
      iex> my_optional = Containers.Optional.to_optional(1)
      iex> my_optional >>> fn(i) -> Containers.Optional.to_optional(i + 1) end
      %Containers.Optional{value: 2}
  """
  def s >>> f, do: Containers.Sequenceable.next(s, f)

  @doc """
  safely unwrap the inner value of a container, proviing a default in case the value is `nil`.
  This is should help prevent runtime errors within a `|>` chain handling strings.


  ## Examples

      iex> my_string = Containers.Text.from_string("hello")
      iex> Containers.safe_unwrap(my_string, "this wont be needed")
      "hello"

      iex> my_nil_string = Containers.Text.from_string(nil)
      iex> Containers.safe_unwrap(my_nil_string, "This will be the value")
      "This will be the value"
  """
  @spec safe_unwrap(unwrappable(), any()) :: any()
  def safe_unwrap(s, default), do: Containers.Unwrappable.safe(s, default)

  @doc """
  unsafely unwrap the inner value of a continer. This may return nil so any guarantees
  against a runtime error no longer apply.

  ## Examples

      iex> my_string = Containers.Text.from_string("Hello")
      iex> Containers.unsafe_unwrap(my_string)
      "Hello"

      iex> my_nil_string = Containers.Text.from_string(nil)
      iex> Containers.unsafe_unwrap(my_nil_string)
      nil
  """
  @spec unsafe_unwrap(unwrappable()) :: any()
  def unsafe_unwrap(s), do: Containers.Unwrappable.unsafe!(s)

  @doc """
  concat a list of Containers that implement the Appendable protocol

  ```
  hello_world = "hello_world"

  hello_world |> String.split("_")
  |> Enum.map(&String.capitalize/1)
  |> Enum.map(&Containers.Text.from_string/1)
  |> Containers.concat()
  |> Containers.safe_unwrap("")

  "HelloWorld"
  ```

  ## Examples

      iex> hello = Containers.Text.from_string("hello")
      iex> world = Containers.Text.from_string(" world")
      iex> excliam = Containers.Text.from_string("!")
      iex> Containers.concat([hello, world, excliam])
      %Containers.Text{value: "hello world!"}
  """
  @spec concat(list()) :: appendable()
  def concat(appendables) do
    appendables
    |> Enum.reverse
    |> Enum.reduce(&append/2)
  end

  @doc """
  This is useful for when you have a container that inner structure of that same container,
  and you want to flatten that down to one level.

  ## Examples

      iex> nested = %Containers.Optional{value: %Containers.Optional{value: "hello"}}
      iex> Containers.flatten(nested)
      %Containers.Optional{value: "hello"}

  """
  @spec flatten(flattenable) :: flattenable
  def flatten(flat), do: Containers.Flattenable.flatten(flat)
end
