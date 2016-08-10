# ExTrello

A library for interfacing with the Trello API.

Heavily influenced by https://github.com/parroty/extwitter with some stuff straight ripped out of it.

TODO:
- [x] ~~Fetch Boards~~
- [x] ~~Create & Edit Boards~~
- [x] ~~Support nested resources~~
- [x] ~~Fetch Cards~~
- [x] ~~Comment on Cards~~
- [x] ~~Create & Edit Cards~~
- [x] ~~Implement own OAuth 1.0 library to remove dependency on `erlang-oauth` (or investigate existing solutions)~~
- [ ] Add models for label, checklist, member, notification, organization, session, token, ~~action~~
- [ ] Usage tutorial. (For now use: https://hexdocs.pm/ex_trello/0.2.4/ExTrello.html)
- [ ] Tests
- [ ] Pagination

## Installation


  1. Add `ex_trello` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:ex_trello, "~> 0.4.0"}
      ]
    end
    ```

  2. Ensure `ex_trello` is started before your application: (Technically not necessary right now, but will be soon(tm).)

    ```elixir
    def application do
      [applications: [:ex_trello]]
    end
    ```
