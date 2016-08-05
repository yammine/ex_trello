# ExTrello

A library for interfacing with the Trello API.

TODO:
- [x] Fetch Boards
- [x] Create & Edit Boards
- [x] Support nested resources
- [x] Fetch Cards
- [x] Comment on Cards
- [ ] Create & Edit Cards
- [ ] Add models for label, checklist, member, notification, organization, session, token, ~~action~~
- [ ] Usage tutorial. (For now use: https://hexdocs.pm/ex_trello/0.2.3/ExTrello.html)
- [ ] Tests
- [ ] Pagination
- [ ] Implement own OAuth 1.0 library to remove dependency on `erlang-oauth` (or investigate existing solutions)

## Installation


  1. Add `ex_trello` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:oauth, github: "tim/erlang-oauth"}, # The erlang-oauth package isn't included
        {:ex_trello, "~> 0.2.3"}
      ]
    end
    ```

  2. Ensure `ex_trello` is started before your application: (Technically not necessary right now, but will be soon(tm).)

    ```elixir
    def application do
      [applications: [:ex_trello]]
    end
    ```
