defmodule ExTrello do
  @moduledoc """
  Provides access interface to the Trello API.
  """
  use Application

  @doc """
  false
  """
  def start(_type, _args) do
    ExTrello.Supervisor.start_link
  end

  # -------------- ExTrello Settings -------------

  @doc """
  Provides OAuth configuration settings for accessing trello server.

  The specified configuration applies globally. Use `ExTrello.configure/2`
  for setting different configurations on each processes.

  ## Examples

      ExTrello.configure(
        app_key: System.get_env("TRELLO_APP_KEY"),
        app_secret: System.get_env("TRELLO_APP_SECRET"),
        access_token: System.get_env("TRELLO_ACCESS_TOKEN"),
        access_token_secret: System.get_env("TRELLO_ACCESS_SECRET")
      )
  """

  @spec configure(Keyword.t) :: :ok
  defdelegate configure(oauth), to: ExTrello.Config, as: :set

  @doc """
  Provides OAuth configuration settings for accessing trello server.

  ## Options

    The `scope` can have one of the following values.

    * `:global` - configuration is shared for all processes.

    * `:process` - configuration is isolated for each process.

  ## Examples

      ExTrello.configure(
        :process,
        app_key: System.get_env("TRELLO_APP_KEY"),
        app_secret: System.get_env("TRELLO_APP_SECRET"),
        access_token: System.get_env("TRELLO_ACCESS_TOKEN"),
        access_token_secret: System.get_env("TRELLO_ACCESS_SECRET")
      )

  """

  @spec configure(:global | :process, Keyword.t) :: :ok
  defdelegate configure(scope, oauth), to: ExTrello.Config, as: :set

  @doc """
  Fetch the authenticated member.

  ## Examples

      ExTrello.member()

  ## Reference
  https://developers.trello.com/advanced-reference/member#get-1-members-idmember-or-username
  """
  @spec member() :: ExTrello.Model.Member
  defdelegate member, to: ExTrello.API.Members

  @doc """
  Fetch the authenticated member. See reference for list of options.

  ## Examples

      ExTrello.member(organizations: "all")

  ## Reference
  https://developers.trello.com/advanced-reference/member#get-1-members-idmember-or-username
  """
  @spec member(Keyword.t) :: ExTrello.Model.Member
  defdelegate member(options), to: ExTrello.API.Members

  @doc """
  Fetch all boards of authenticated user.

  ## Examples

      ExTrello.boards()
  """
  @spec boards() :: [ExTrello.Model.Board] | []
  defdelegate boards, to: ExTrello.API.Boards

  @doc """
  Fetch all boards of authenticated user. See reference for detailed list of options.

  ## Examples

      ExTrello.boards([filter: "pinned,public", fields: "shortLink,subscribed"])

  ## Reference
  https://developers.trello.com/advanced-reference/member#get-1-members-idmember-or-username-boards
  """
  @spec boards(Keyword.t) :: [ExTrello.Model.Board] | []
  defdelegate boards(options), to: ExTrello.API.Boards


  @doc """
  Fetch all boards of given username or Trello User ID. See reference for detailed list of options.

  ## Examples

      ExTrello.boards("trello")

  ## Reference
  https://developers.trello.com/advanced-reference/member#get-1-members-idmember-or-username-boards
  """
  @spec boards(String.t, Keyword.t) :: [ExTrello.Model.Board] | []
  defdelegate boards(user, options), to: ExTrello.API.Boards

  @doc """
  Fetch board with board_id.

  ## Examples

      ExTrello.board("57663306e4b15193fcc97483")

  ## Reference
  https://developers.trello.com/advanced-reference/board#get-1-boards-board-id
  """
  @spec board(String.t) :: ExTrello.Model.Board.t | nil
  defdelegate board(id), to: ExTrello.API.Boards

  @doc """
  Fetch board with board_id. See reference for list of options.

  ## Examples

      ExTrello.board("57663306e4b15193fcc97483", [actions_display: true])

  ## Reference
  https://developers.trello.com/advanced-reference/board#get-1-boards-board-id
  """

  @spec board(String.t, Keyword.t) :: ExTrello.Model.Board.t | nil
  defdelegate board(id, options), to: ExTrello.API.Boards

  @doc """
  Create board with supplied `name`.

  ## Examples
      # Bad
      ExTrello.create_board(123) #=> %ExTrello.Error{code: 422, message: "You must provide a name with a length between 1 and 16384 to create a board."}

      # Good
      ExTrello.create_board("TrelloHub")


  ## Reference
  https://developers.trello.com/advanced-reference/board#post-1-boards
  """

  @spec create_board(String.t) :: ExTrello.Model.Board.t | nil
  defdelegate create_board(name), to: ExTrello.API.Boards

  @doc """
  Create board with supplied `name`. See reference for detailed list of options.

  ## Examples
      # Bad
      ExTrello.create_board(123) #=> %ExTrello.Error{code: 422, message: "You must provide a name with a length between 1 and 16384 to create a board."}

      # Good
      ExTrello.create_board("TrelloHub", desc: "An application to synchronize your Trello boards with your GitHub activity.", powerups: "all")


  ## Reference
  https://developers.trello.com/advanced-reference/board#post-1-boards
  """

  @spec create_board(String.t, Keyword.t) :: ExTrello.Model.Board.t | nil
  defdelegate create_board(name, options), to: ExTrello.API.Boards

  @doc """
  Edit board with supplied field values. See reference for detailed list of options.

  ## Examples
      # Capture the id of our newly created board.
      %ExTrello.Model.Board{id: id} = ExTrello.create_board("Some name")
      # Let's edit the name of our new board.
      ExTrello.edit_board(id, name: "Another name entirely.")

  ## Reference
  https://developers.trello.com/advanced-reference/board#put-1-boards-board-id
  """

  @spec edit_board(String.t, Keyword.t) :: ExTrello.Model.Board.t | nil
  defdelegate edit_board(id, options), to: ExTrello.API.Boards

  @doc """
  Fetch cards associated to %ExTrello.Model.Board{} or board id.

  ## Examples

      # Using a board_id
      ExTrello.board_cards("57663306e4b15193fcc97483")

      # Using a Board struct (Useful in case you're passing this struct around, you should just use the `cards: "all"` flag to fetch a board and its cards in the same request)
      # board = %ExTrello.Model.Board{id: "57663306e4b15193fcc97483" blah blah blah}
      board |> ExTrello.board_cards

  ## Reference
  https://developers.trello.com/advanced-reference/board#get-1-boards-board-id-cards
  """
  @spec board_cards(String.t | ExTrello.Model.Board.t) :: [ExTrello.Model.Card.t] | []
  defdelegate board_cards(board_or_id), to: ExTrello.API.Boards, as: :cards

  @doc """
  Fetch cards associated to %ExTrello.Model.Board{} or board id. See reference for detailed list of options.

  ## Examples

      # Using a board_id
      ExTrello.board_cards("57663306e4b15193fcc97483", attachments: true, checklists: "all")

      # Using a Board struct (Useful in case you're passing this struct around, you should just use the `cards: "all"` flag to fetch a board and its cards in the same request)
      # board = %ExTrello.Model.Board{id: "57663306e4b15193fcc97483" blah blah blah}
      board |> ExTrello.board_cards(members: true)

  ## Reference
  https://developers.trello.com/advanced-reference/board#get-1-boards-board-id-cards
  """

  @spec board_cards(String.t | ExTrello.Model.Board.t, Keyword.t) :: [ExTrello.Model.Card.t] | []
  defdelegate board_cards(board_or_id, options), to: ExTrello.API.Boards, as: :cards

  @doc """
  Fetch card associated with given id or shortlink.

  ## Examples

      # Using card id
      ExTrello.card("56e8fa38abbbdd74b978c3cd")

      # Using shortlink
      ExTrello.card("JyUbYknO")

  ## Reference
  https://developers.trello.com/advanced-reference/card#get-1-cards-card-id-or-shortlink
  """
  @spec card(String.t) :: ExTrello.Model.Card.t
  defdelegate card(card_id_or_shortlink), to: ExTrello.API.Cards

  @doc """
  Fetch card associated with given id or shortlink with options. See reference for detailed list of options.

  ## Examples

      ExTrello.card("JyUbYknO", list: true)

  ## Reference
  https://developers.trello.com/advanced-reference/card#get-1-cards-card-id-or-shortlink
  """

  @spec card(String.t, Keyword.t) :: ExTrello.Model.Card.t
  defdelegate card(card_id_or_shortlink, options), to: ExTrello.API.Cards

  @doc """
  Create a card for a given %List{} or list id.

  ## Examples

      board = ExTrello.board("57663306e4b15193fcc97483", lists: "all")
      %ExTrello.Model.List{id: id} = List.first(board.lists) # This happens to be my Icebox list
      ExTrello.create_card(id, "Should definitely improve documentation and tests for this project.")

  ## Reference
  https://developers.trello.com/advanced-reference/card#post-1-cards
  """

  @spec create_card(String.t | ExTrello.Model.List.t, String.t) :: ExTrello.Model.Card.t
  defdelegate create_card(list_or_id, name), to: ExTrello.API.Cards

  @doc """
  Create a card for a given %List{} or list id using provided options. See reference for detailed list of options.

  ## Examples

      board = ExTrello.board("57663306e4b15193fcc97483", lists: "all", members: "all")

      List.first(board.lists) # This happens to be my Icebox list
      |> ExTrello.create_card("This card will be at the top of the list.", pos: "top", idMembers: Enum.map(board.members, &(&1.id)) |> Enum.join(","))

  ## Reference
  https://developers.trello.com/advanced-reference/card#post-1-cards
  """

  @spec create_card(String.t | ExTrello.Model.List.t, String.t, Keyword.t) :: ExTrello.Model.Card.t
  defdelegate create_card(list_or_id, name, options), to: ExTrello.API.Cards

  @doc """
  Edit a card. A comprehensive list of all properties that can be passed can be found in the reference.

  ## Examples

      # Using ID
      ExTrello.edit_card("56e8fa38abbbdd74b978c3cd", name: "A different name now.", desc: "Honestly does anyone even read these?", pos: "top", idList: "57663322ac7d147b2c337e34")

      # Using Shortlink
      ExTrello.edit_card("JyUbYknO", closed: true, subscribed: false)

      # Using a %ExTrello.Model.Card{} struct
      ExTrello.card("JyUbYknO")
      |> ExTrello.edit_card(name: "I passed an ExTrello.Model.Card struct to the function to edit this card.")

  ## Reference
  https://developers.trello.com/advanced-reference/card#put-1-cards-card-id-or-shortlink
  """

  @spec edit_card(String.t | ExTrello.Model.Card.t, Keyword.t) :: ExTrello.Model.Card.t
  defdelegate edit_card(card_or_id_or_shortlink, properties_to_edit), to: ExTrello.API.Cards

  @doc """
  Create a comment on a given card.

  ## Examples

      ExTrello.create_comment("JyUbYknO", "Passed code review, moving this to the `Complete` list.")

  ## Reference
  https://developers.trello.com/advanced-reference/card#post-1-cards-card-id-or-shortlink-actions-comments
  """
  @spec create_comment(String.t | ExTrello.Model.Card.t, String.t) :: ExTrello.Model.Action.t
  defdelegate create_comment(card_or_id_or_shortlink, text), to: ExTrello.API.Cards

  @doc """
  Fetch action associated with action_id.

  ## Examples

      ExTrello.action("57a5108615c475280d511795")

  ## Reference
  https://developers.trello.com/advanced-reference/action#actions-idaction
  """

  @spec action(String.t) :: ExTrello.Model.Action.t
  defdelegate action(action_id), to: ExTrello.API.Actions

  @doc """
  Fetch list associated with list_id or %List{} struct

  ## Examples

      # Using id
      ExTrello.list("57663322ac7d147b2c337e34")

      # Using a struct
      ExTrello.list(%ExTrello.Model.List{...})

  ## Reference
  https://developers.trello.com/advanced-reference/list#get-1-lists-idlist
  """
  @spec list(String.t | ExTrello.Model.List.t) :: ExTrello.Model.List.t
  defdelegate list(id_or_struct), to: ExTrello.API.Lists

  @doc """
  Fetch list associated with list_id or %List{} struct and options. See reference for detailed list of options.

  ## Examples

      ExTrello.list("57663322ac7d147b2c337e34", board: true, fields: "all")

  ## Reference
  https://developers.trello.com/advanced-reference/list#get-1-lists-idlist
  """
  @spec list(String.t | ExTrello.Model.List.t, Keyword.t) :: ExTrello.Model.List.t
  defdelegate list(id_or_struct, options), to: ExTrello.API.Lists

  @doc """
  Creates list on specified board using id or struct with specified name.

  ## Examples

      # Using board id
      ExTrello.create_list("57663306e4b15193fcc97483", "The name of the list")

      # Using board struct
      board = ExTrello.board("57663306e4b15193fcc97483")
      # Do some stuff with the board... then you wanna create a list

      ExTrello.create_list(board, "Also the name of a list")

  ## Reference
  https://developers.trello.com/advanced-reference/list#post-1-lists
  """
  @spec create_list(String.t | ExTrello.Model.Board.t, String.t) :: ExTrello.Model.List.t
  defdelegate create_list(board_id_or_struct, name), to: ExTrello.API.Lists

  @doc """
  Creates list on specified board using id or struct with specified name. See reference for detailed list of options.

  ## Examples

      # Using board id
      ExTrello.create_list("57663306e4b15193fcc97483", "The name of the list", pos: "top")

      # Using board struct
      board = ExTrello.board("57663306e4b15193fcc97483")
      # Do some stuff with the board... then you wanna create a list

      ExTrello.create_list(board, "Also the name of a list", idListSource: "some_list_id")

  ## Reference
  https://developers.trello.com/advanced-reference/list#post-1-lists
  """
  @spec create_list(String.t | ExTrello.Model.Board.t, String.t, Keyword.t) :: ExTrello.Model.List.t
  defdelegate create_list(board_id_or_struct, name, options), to: ExTrello.API.Lists

  @doc """
  Edits list using specified id or struct with fields

  ## Examples

    # Using id
    ExTrello.edit_list("57b619a0e1714100f54bc33c", name: "Ridiculous Ideas")

    # Using struct
    ExTrello.list("57b619a0e1714100f54bc33c")
    |> ExTrello.edit_list(name: "Pipes ahoy")

  ## Reference
  https://developers.trello.com/advanced-reference/list#put-1-lists-idlist
  """
  @spec edit_list(String.t | ExTrello.Model.List.t, Keyword.t) :: ExTrello.Model.List.t
  defdelegate edit_list(list_id_or_struct, fields), to: ExTrello.API.Lists

  @doc """
  GET request to Trello

  ## Examples

      ExTrello.get("boards/57ae3940f43e6d960e0c45da/boardStars", filter: "mine")
  """
  @spec get(String.t, Keyword.t) :: String.t
  defdelegate get(path, params \\ []), to: ExTrello.API.BareRequests

  @doc """
  POST request to Trello

  ## Examples

      ExTrello.post("boards/57ae3940f43e6d960e0c45da/lists", name: "Best List", pos: "top")
  """
  @spec post(String.t, Keyword.t) :: String.t
  defdelegate post(path, params \\ []), to: ExTrello.API.BareRequests

  @doc """
  PUT request to Trello

  ## Examples

      ExTrello.put("boards/57ae3940f43e6d960e0c45da/labelNames/blue", value: "Bluey")
  """
  @spec put(String.t, Keyword.t) :: String.t
  defdelegate put(path, params \\ []), to: ExTrello.API.BareRequests

  @doc """
  DELETE request to Trello

  ## Examples

      ExTrello.delete("boards/57ae3940f43e6d960e0c45da/powerUps/calendar")
  """
  @spec delete(String.t, Keyword.t) :: String.t
  defdelegate delete(path, params \\ []), to: ExTrello.API.BareRequests

  @doc """
  GET OAuthGetRequestToken

  ## Examples

      ExTrello.request_token("http://localhost:4000/auth/trello/callback/1234")

  ## Reference
  https://trello.com/app-key
  """
  @spec request_token(String.t) :: [ExTrello.Model.RequestToken.t]
  defdelegate request_token(return_url), to: ExTrello.API.Auth

  @doc """
  GET OAuthAuthorizeToken

  ## Examples

      token = ExTrello.request_token("http://localhost:4000/auth/trello/callback/1234")
      ExTrello.authorize_url(token.oauth_token, return_url: "http://localhost:4000/auth/trello/callback/1234", scope: "read,write", expiration: "never", name: "Example Authentication")

  Returns the URL you should redirect the user to for authorization
  """
  @spec authorize_url(String.t, Keyword.t | Map.t) :: {:ok, String.t}
  defdelegate authorize_url(oauth_token, options), to: ExTrello.API.Auth

  @doc """
  GET OAuthAuthorizeToken

  ## Examples

      token = ExTrello.request_token
      ExTrello.authorize_url(token.oauth_token)

  Returns the URL you should redirect the user to for authorization
  """
  @spec authorize_url(String.t) :: {:ok, String.t}
  defdelegate authorize_url(oauth_token), to: ExTrello.API.Auth

  @doc """
  GET OAuthGetAccessToken

  ## Examples

      ExTrello.access_token("OAUTH_VERIFIER", "OAUTH_TOKEN", "OAUTH_TOKEN_SECRET")
  """
  @spec access_token(String.t, String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  defdelegate access_token(verifier, request_token, request_token_secret), to: ExTrello.API.Auth

end
