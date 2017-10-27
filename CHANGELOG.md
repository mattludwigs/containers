# Change Log

All notable changes to this project will be documented in this file (at least to the extent possible, I am not infallible sadly).
This project adheres to [Semantic Versioning](http://semver.org/).

## 0.7.1

### Changed

- Updated documentation

## 0.7.0

### Changed

- `Containers.next` function to be named `and_then` **This is a breaking change**
- `Containers.next` function in `Containers.Sequenceable` to be `and_then` **This is a breaking change**
- `Containers.Flattenable` protocol is now named `Containers.Joinable` **This is a breaking change**
- `Containers.flatten` function is now named `Containers.join` **This is a breaking change**

## 0.6.2

### Added

- `mapn` function, which will allow for lifting a mapping function into `n` number of nested mappable containers.
- Some documentation clean up.

## 0.6.1

### Added

- Implemented the `Mappable protocol` for Elixir's List. Now you can call `Containers.map` on a normal list.
- Added `Containers.map2`, which will allow you to pass a mapping function to map on a nested mapable structure.

## 0.6.0

### Added

- `Containers.Flattenable` protocol for flattening nested containers
- `Containers.flatten` a function to perform the flattening of Flattenable containers
- some internal code clean up.

### Changed

- `Containers.map` on the `Result` container will call the function when the Result container value
   is `:ok`. Before it would just ignore the function returning the Result container. Now we can map
   that container and the mapping function will return a new Result with the inner value as
   `{:ok, return_from_function}`. **This is a breaking change**.

## 0.5.0

### Added

- `Containers.Classy.List` module to provide total/consistent function support to the List module.

### Changed

- `Containers.Int` is now `Containers.Classy.Integer`. This is a breaking change.

## 0.4.0

### Added

- Types for documentation

### Changed

- `Containers.Result.from_tuple` is now `Containers.Result.to_result` to support `:ok`, and `:error` stand alone atoms
- Documentation updates

## 0.3.2

### Added

- `Container.Int` module
