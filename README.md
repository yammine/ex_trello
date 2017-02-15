# ExTrello [![Build Status](https://travis-ci.org/ChrisYammine/ex_trello.svg?branch=master)](https://travis-ci.org/ChrisYammine/ex_trello)[![Coverage Status](https://coveralls.io/repos/github/ChrisYammine/ex_trello/badge.svg)](https://coveralls.io/github/ChrisYammine/ex_trello)[![Hex.pm](https://img.shields.io/hexpm/v/ex_trello.svg?maxAge=2592000)](https://hex.pm/packages/ex_trello)[![Hex.pm Downloads](https://img.shields.io/hexpm/dt/ex_trello.svg?maxAge=2592000)](https://hex.pm/packages/ex_trello)[![Deps Status](https://beta.hexfaktor.org/badge/all/github/ChrisYammine/ex_trello.svg)](https://beta.hexfaktor.org/github/ChrisYammine/ex_trello)[![Inline docs](http://inch-ci.org/github/ChrisYammine/ex_trello.svg?branch=master&style=shields)](http://inch-ci.org/github/ChrisYammine/ex_trello)

A library for interfacing with the Trello API.

Heavily influenced by https://github.com/parroty/extwitter with some stuff straight ripped out of it.

## **Important! Migration from 0.x -> 1.x**
Since this change will break all existing projects using ExTrello upon upgrading this deserves a spot at the top :)

All calls to the Trello API will now be wrapped in a tuple with the first element either being `:ok`, `:error`, or `:connection_error`
Regular errors will no longer raise exceptions as that is not idiomatic.

Here's an example(just a little sample):
```elixir
# Old and bad
boards = ExTrello.boards()
# New and great
{:ok, boards} = ExTrello.boards()

# Old and bad, yuck!
try do
  ExTrello.get("potato/2")
rescue
  %ExTrello.Error{code: code, message: message} -> IO.puts "ERROR[#{code}] - #{message}"
end

# New and fantastic
case ExTrello.get("potato/2") do
  {:ok, response} -> response
  {:error, %ExTrello.Error{code: code, message: message}} -> IO.puts "ERROR[#{code}] - #{message}"
  {:connection_error, %ExTrello.ConnectionError{reason: _, message: message}} -> IO.puts "#{message} We should retry."
end
```

## Documentation
- https://hexdocs.pm/ex_trello


## Installation


  1. Add `ex_trello` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        ...,
        {:ex_trello, "~> 1.0.1"}
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
    :ok = ExTrello.configure(
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

#### Authorize your application

Example for authorization. This is a naive solution that only works for demonstration.
TODO: Set up example application.
```elixir
# First we have to get a request token from Trello.
{:ok, token} = ExTrello.request_token("http://localhost:4000/auth/trello/callback/1234")
# We have to store this token because we need the `oauth_token_secret` after the callback to obtain our access token & secret.
# e.g. TokenAgent.store("1234", token.oauth_token_secret)

# Generate the url for authorization
{:ok, auth_url} = ExTrello.authorize_url(token.oauth_token, %{return_url: "http://localhost:4000/auth/trello/callback/1234", scope: "read,write", expiration: "never", name: "Your Application Name here"})

# Copy the url and visit it using your browser.
IO.puts auth_url
```
After signing in/authorizing the application you will be redirected to the callback URL you specified in the Request token & authorize URL.

Example:
```
http://localhost:4000/auth/trello/callback/1234?oauth_token=**copy_this**&oauth_verifier=**copy_this**
```

Copy the `oauth_token` and `oauth_verifier` above:
```elixir
oauth_token = "copied_oauth_token"
oauth_verifier = "copied_oauth_verifier"
oauth_token_secret = retrieve_oauth_token_secret_from_before() # e.g. TokenAgent.retrieve("1234") from hypothetical TokenAgent

{:ok, access_token} = ExTrello.access_token(oauth_verifier, oauth_token, oauth_token_secret)

# Let's configure ExTrello with our newly obtained access token
ExTrello.configure(
  consumer_key: System.get_env("TRELLO_CONSUMER_KEY"),
  consumer_secret: System.get_env("TRELLO_CONSUMER_SECRET"),
  token: access_token.oauth_token,
  token_secret: access_token.oauth_token_secret
)

# Testing our token!
{:ok, member} = ExTrello.member() # Fetches the authenticated member record from Trello
```


## TODO:
- [x] ~~Fetch Boards~~
- [x] ~~Create & Edit Boards~~
- [x] ~~Support nested resources~~
- [x] ~~Fetch Cards~~
- [x] ~~Comment on Cards~~
- [x] ~~Create & Edit Cards~~
- [x] ~~Implement own OAuth 1.0 library to remove dependency on `erlang-oauth` (or investigate existing solutions)~~
- [x] ~~Usage tutorial.~~
- [x] ~~Tests (IN PROGRESS)~~
- [ ] Add models for ~~label~~, ~~checklist~~, ~~member~~, notification, ~~organization~~, session, token, ~~action~~
- [ ] Pagination
- [ ] Example Application
- [ ] Investigate handling storage of request_token.oauth_token_secret instead of leaving that up to the dev.


## LICENSE
The MIT License (MIT)
Copyright (c) 2016 Christopher Yammine

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
