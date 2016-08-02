# ExTrello

A library for interfacing with the Trello API.

TODO:
- [x] Fetch Boards
- [x] Create & Edit Boards
- [ ] Usage tutorial. (For now use: https://hexdocs.pm/ex_trello/0.2.1/ExTrello.html)
- [ ] Support nested resources (fetching cards for a particular board in 1 request)
- [ ] Pagination
- [ ] Fetch Cards
- [ ] Create & Edit Cards
- [ ] Comment on Cards

## Installation


  1. Add `ex_trello` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:oauth, github: "tim/erlang-oauth"}, # The erlang-oauth package isn't included
        {:ex_trello, "~> 0.1.9"}
      ]
    end
    ```

  2. Ensure `ex_trello` is started before your application:

    ```elixir
    def application do
      [applications: [:ex_trello]]
    end
    ```
