# Maybex

The maybe monad is a way to handle values that might be nil without exploding our programs. Thhe approach taken here is to begin by wrapping the function that might return a nil in an `Either`.

```elixir
Either.new(function_that_might_return_nil)
```

This will return either (see what I did there) a `Left` or a `Right`. `Left`'s are containers `nil` values. Everything else will be contained in a `Right`. That is to say, if the function we pass to an `Either` actually returns a nil, we will get a `%Left{value: nil}` out. If it returns any other value, we will get a `%Right{}`, with the result of the function contained inside.

What does this buy us?

Lets assume we want to do something to the value inside of the result of the `Either.new`. We would need to `map` over the thing that gets returned with a function. If we implement the same function differently for a `Left` and a `Right`, we can do two different things depending on the type of the thing that gets piped into map: 

```elixir
Either.new(function_that_might_return_nil) |> Maybe.map(fn (x) -> x + 10 end)
```

If we didn't wrap our value in a `Right` or a `Left`, then sometimes a nil would be passed to the `map` function, and we would explode with an error. But now we can either (in the case of a `Right`) apply the function to the value contained in the right, OR, in the case of the `Left` choose to simply ignore the function and return the left unchanged.

We have the ability to do two different things without having to  write an `if`!

`Left` and `Right` implement a `map` and a `fold` function. See [the docs](https://hexdocs.pm/maybex) for more info on what they do.

Here are some example use cases:

```elixir
iex: Either.new(nil) |> Maybe.map(fn (x)-> x * 10 end) |> Maybe.fold(fn (x)-> "We cant add ten to nil" end, fn (x) -> x end)
...: "We cant add ten to nil"
```

```elixir
iex: Either.new(10) |> Maybe.map(fn (x)-> x * 10 end) |> Maybe.fold(fn (x)-> "We cant add ten to nil" end, fn (x) -> x end)
...: 100
```

## Installation

This is [available in Hex](https://hex.pm/packages/maybex), the package can be installed
by adding `maybex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:maybex, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/maybex](https://hexdocs.pm/maybex).

## Tests

To run tests, at the root of the project run `mix test`

## Contributing

Pull requests and issues are welcome!


## TODO

- Partial function application / currying.
- Expand on safe_pipe idea and name better
- test more thoroughly (prop tests?)
=================================================================================================================================================

