# Maybex

This is a pragmatic implementation of the Maybe monad. It allows you to pipe together functions with abandon, even if they return error values.

### Why would I use it?

<details>
  <summary>Let's look at a completely contrived example.</summary>
Imagine you get some data and you want to turn it to json then save somewhere:

```elixir
{:ok, %{valid?: true, data: "DATA!"}}
|> turn_into_json()
|> save_to_the_db()
```

Let's say they are implemented like this:

```elixir
def turn_into_json(%{valid?: false}), do: {:error, "Nope"}
def turn_into_json(data), do: {:ok, Jason.encode!(data)}

def save_to_the_db(json), do: DB.save(json)
```

Notice the problem? The return from `turn_into_json` doesn't match what `save_to_the_db` expects. So we have two options.

  1. define `save_to_the_db` such that it can handle an okay / error tuple.
  2. use  `with`.

The first approach would look like this:

```elixir
def save_to_the_db({:ok, json}), do: DB.save(json)
def save_to_the_db({:error, json}), do: {:error, json}
def save_to_the_db(json), do: DB.save(json)
```

There are lots of reasons why it feels wrong. It's not the concern of `save_to_the_db` what `turn_into_json` returns. If `turn_into_json` changes we shouldn't have to also change `save_to_the_db`, so if we do 1. we've introduced coupling that we do not want. Worse than that if we add more functions in between `save_to_the_db` and `turn_into_json` they would also all have to handle an okay / error tuple, which adds overhead. `save_to_the_db` can't handle all of the possible inputs it might get and it shouldn't. In elixir this is easy to do because of pattern matching so is often tempting, but should be avoided.

Option 2 looks like this:

```elixir
data = {:ok, %{valid?: true, data: "DATA!"}}

with {:ok, next} <- turn_into_json(data) do
  save_to_the_db(next)
else
  {:error, "Nope"} -> {:error, "Nope"}
end
```

That's much more reasonable, but even this can get unwieldy quickly. If we add more functions, we have to handle them each in the `else` clause, some may return error tuples, some may return nil:

```elixir
data = {:ok, %{valid?: true, data: "DATA!"}}

with {:ok, next} <- turn_into_json(data),
  result <- spin_it_around_a_bit(next),
  x when not is_nil(x) <- nullable_fun(result) do
  save_to_the_db(x)
else
  nil -> {:error, "Nope"}
  {:error, "Nope"} -> {:error, "Nope"}
end
```
Which again may be fine in small doses, but Maybex offers an alternative:

```elixir
{:ok, %{valid?: true, data: "DATA!"}}
|> Maybe.map(&turn_into_json/1)
|> Maybe.map(&save_to_the_db/1)
```
</details>

### How would I use it?

Here's how it works. Generally there are two types of things, there are error things and non error things. You can define for yourself what specifically counts as an error, and what isn't, but Maybex provides a few for you. We define `{:error, thing}` as an error thing, and `{:ok, thing}` as a non error thing.

If we pass `{:ok, thing}` into `Maybe.map/2` we will pass `thing` into the mapping function, and return that result wrapped in an okay tuple. If we map over an `{:error, thing}` we wont do anything, and will just return the error tuple:

```elixir
iex> {:ok, 10} |> Maybe.map(fn x -> x * 10 end)
{:ok, 100}

iex> {:error, 10} |> Maybe.map(fn x -> x * 10 end)
{:error, 10}

iex> {:ok, 10}
...> |> Maybe.map(fn x -> x * 10 end)
...> |> Maybe.map(fn _x -> {:error, "Nope!"} end)
...> |> Maybe.map(fn x -> x * 10 end)
{:error, "Nope!"}

iex> Maybe.unwrap({:ok, 10})
10

iex> Maybe.unwrap({:error, 10})
10

iex> Maybe.map_error({:error, 10}, fn x -> x * 10 end)
{:error, 100}
```

Maybex has been implemented using protocols, meaning it is extendable by you yes you. Instead of tuples you can use an `Ok` struct and an `Error` struct instead:


```elixir
iex> %Ok{value: 10} |> Maybe.map(fn x -> x * 10 end)
%Ok{value: 100}

iex> %Error{value: 10} |> Maybe.map(fn x -> x * 10 end)
%Error{value: 10}

iex> %Ok{value: 10}
...> |> Maybe.map(fn x -> x * 10 end)
...> |> Maybe.map(fn _x -> %Error{value: "Nope!"} end)
...> |> Maybe.map(fn x -> x * 10 end)
%Error{value: "Nope!"}

iex> Maybe.unwrap(%Ok{value: 10})
10

iex> Maybe.unwrap(%Error{value: 10})
10

iex> Maybe.map_error(%Error{value: 10}, fn x -> x * 10 end)
%Error{value: 100}
```


There are a list of functions that behave similarly check [the docs](https://hexdocs.pm/maybex) for more thorough examples.


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
