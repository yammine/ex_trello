# ExTrello

A library for interfacing with the Trello API.

Heavily influenced by https://github.com/parroty/extwitter with some stuff straight ripped out of it.

## Installation


  1. Add `ex_trello` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        ...,
        {:ex_trello, "~> 0.4.2"}
      ]
    end
    ```

  2. Ensure `ex_trello` is started before your application:

    ```elixir
    def application do
      [applications: [:ex_trello]]
    end
    ```
  3. Run `mix deps.get`

## Usage
1. Make sure you've completed [installation.](#installation)
2. Use `ExTrello.configure` to setup Trello's OAuth authentication parameters.
3. Call functions in the `ExTrello` module. (e.g. `ExTrello.boards()`)

### Configuration
The default behavior is for ExTrello to use the application environment:

In `config/<env>.exs` add:

```elixir
# I like using ENV vars to populate my configuration. But fill this out however you'd like :)
config :ex_trello, :oauth, [
  consumer_key:    System.get_env("TRELLO_CONSUMER_KEY"),
  consumer_secret: System.get_env("TRELLO_CONSUMER_SECRET"),
  token:           System.get_env("TRELLO_ACCESS_TOKEN"),
  token_secret:    System.get_env("TRELLO_ACCESS_SECRET")
]
```

You can also manually configure it at runtime:
```elixir
ExTrello.configure(consumer_key: "...", ...)
```

You can also configure for the current process only:
```elixir
defmodule TrelloServer do 
  use GenServer
  
  def start_link(user) do 
    GenServer.start_link(__MODULE__, user, [])
  end
  
  def init(%User{token: token, token_secret: token_secret}) do 
    ExTrello.configure(
      :process,
      consumer_key: System.get_env("TRELLO_CONSUMER_KEY"),
      consumer_secret: System.get_env("TRELLO_CONSUMER_SECRET"),
      token: token,
      token_secret: token_secret
    )
    {:ok, %{boards: []}}
  end
  
  # Rest of your code...
end
```

## Samples

Coming soon :)

## TODO:
- [x] ~~Fetch Boards~~
- [x] ~~Create & Edit Boards~~
- [x] ~~Support nested resources~~
- [x] ~~Fetch Cards~~
- [x] ~~Comment on Cards~~
- [x] ~~Create & Edit Cards~~
- [x] ~~Implement own OAuth 1.0 library to remove dependency on `erlang-oauth` (or investigate existing solutions)~~
- [ ] Add models for label, checklist, ~~member~~, notification, ~~organization~~, session, token, ~~action~~
- [ ] Usage tutorial. (For now use: https://hexdocs.pm/ex_trello/0.4.2/ExTrello.html)
- [ ] Tests
- [ ] Pagination


## LICENSE
The MIT License (MIT)
Copyright (c) 2016 Christopher Yammine

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
