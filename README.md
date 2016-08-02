# ExTrello

A library for interfacing with the Trello API.

TODO: 
- [ ] Usage tutorial. If someone wants to write one I'll happily accept a PR. :)
- [ ] Support nested resources (fetching cards for a particular board in 1 request)
- [ ] Pagination
- [x] Fetch Boards
- [ ] Create & Edit Boards
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

