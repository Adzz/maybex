# Maybex

This allows us to pipe chains of functions seamlessly, returning early if any one of them fails. This means we wont run a function if we pass it something which we have defined as erroneous. It might be best to see examples:

```elixir
{:ok, 10}
|> Maybe.map(fn x -> x * 10 end)
# {:ok, 100}

{:ok, 10}
|> Maybe.map(fn x -> x * 10 end)
|> Maybe.unwrap!()

{:ok, 10}
|> Maybe.map(fn x -> x * 10 end)
|> Maybe.map(fn x -> {:error, "Nope!"} end)
# {:error, "Nope!"}
```

## Installation

This is [available in Hex](https://hex.pm/packages/maybex), the package can be installed
by adding `maybex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:maybex, "~> 1.0.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/maybex](https://hexdocs.pm/maybex).

## Tests

To run tests, at the root of the project run `mix test`

## Contributing

Pull requests and issues are welcome!


## TODO

- Expand on safe_pipe idea and name better
- test more thoroughly (prop tests?)
