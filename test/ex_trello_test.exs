defmodule ExTrelloTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock
  doctest ExTrello

  alias ExTrello.Model.{Action, Board, Card, Member, Organization}
  alias ExTrello.Model.List, as: TrelloList # Necessary because Elixit.List module is being used in these tests

  setup_all do
    HTTPotion.start # Ensure :httpotion is started.

    ExVCR.Config.filter_request_headers("Authorization")
    ExVCR.Config.filter_sensitive_data("oauth_signature=[^\"]+", "<REMOVED>")
    ExVCR.Config.filter_sensitive_data("access_token\":\".+?\"", "access_token\":\"<REMOVED>\"")
    ExVCR.Config.filter_sensitive_data("dsc=.+;", "<REMOVED>")
    ExVCR.Config.cassette_library_dir("fixtures/vcr_cassettes")

    ExTrello.configure(
      consumer_key:    System.get_env("TRELLO_CONSUMER_KEY"),
      consumer_secret: System.get_env("TRELLO_CONSUMER_SECRET"),
      token:           System.get_env("TRELLO_ACCESS_TOKEN"),
      token_secret:    System.get_env("TRELLO_ACCESS_SECRET")
    )

    :ok
  end

  test "gets current configuration" do
    config = ExTrello.Config.get
    assert Keyword.has_key?(config, :consumer_key)
    assert Keyword.has_key?(config, :consumer_secret)
    assert Keyword.has_key?(config, :token)
    assert Keyword.has_key?(config, :token_secret)
  end

  describe "Bare requests" do
    test "Uses the `ExTrello.get` function to utilize Trello's search functionality" do
      use_cassette "bare_get_request" do
        search = ExTrello.get("search/members", query: "trello", limit: 1)

        assert Enum.count(search) == 1
      end
    end

    test "Expect failure when trying to get invalid endpoint" do
      use_cassette "bare_get_failure" do
        assert_raise ExTrello.Error, "Cannot GET /1/fake_af?", fn ->
          ExTrello.get("fake_af")
        end
      end
    end

    test "Uses the `ExTrello.post` function to create a checklist" do
      use_cassette "bare_post_request" do
        response = ExTrello.post("cards/570ddfcab92fb2f520a02361/checklists", name: "The best checklist.")

        assert response.name == "The best checklist."
        assert is_list(response.check_items)
      end
    end

    test "Expect failure when trying to post to invalid endpoint" do
      use_cassette "bare_post_failure" do
        assert_raise ExTrello.Error, "Cannot POST /1/potatoes/2361/yukon_gold", fn ->
          ExTrello.post("potatoes/2361/yukon_gold")
        end
      end
    end

    test "Uses the `ExTrello.put` function to edit our checklist's name" do
      use_cassette "bare_put_request" do
        response = ExTrello.put("checklists/57b230dc836aa21fa2f869ca", name: "The second best checklist.")

        assert response.name == "The second best checklist."
      end
    end

    test "Expect failure when trying to put to invalid endpoint" do
      use_cassette "bare_put_failure" do
        assert_raise ExTrello.Error, "Cannot PUT /1/put-tatoes", fn ->
          ExTrello.put("put-tatoes")
        end
      end
    end

    test "Uses the `ExTrello.delete` function to delete a checklist" do
      use_cassette "bare_delete_request" do
        response = ExTrello.delete("checklists/57b23300b84c35298ce2d22c") #=> %{_value: nil}

        assert response._value == nil
      end
    end

    test "Expect failure when trying to delete to invalid endpoint" do
      use_cassette "bare_delete_failure" do
        assert_raise ExTrello.Error, "Cannot DELETE /1/delete-tatoes", fn ->
          ExTrello.delete("delete-tatoes", some_param: "ayy")
        end
      end
    end

  end

  describe "Fetching boards from Trello" do

    test "gets the authenticated user's boards" do
      use_cassette "authenticated_user_boards" do
        boards = ExTrello.boards
        assert Enum.count(boards) == 10
      end
    end

    test "gets the specified user's boards" do
      use_cassette "specific_user_boards" do
        first_board = ExTrello.boards("trello") |> List.first
        assert first_board.name == "How to Use Trello for Android"
      end
    end

    test "gets specified user's boards with options" do
      use_cassette "specific_user_boards_with_options" do
        boards = ExTrello.boards("trello", actions: "all", lists: "all")

        assert is_list(boards)
        assert match?([%Board{}|_], boards)
        assert List.first(boards) |> Map.has_key?(:actions)
        assert List.first(boards) |> Map.has_key?(:lists)
      end
    end

    test "gets the specified board using id" do
      use_cassette "get_board_using_id" do
        board = ExTrello.board("57663306e4b15193fcc97483")
        assert board.name == "Lunch Money"
      end
    end

    test "gets the specified board using shortlink" do
      use_cassette "get_board_using_shortlink" do
        board = ExTrello.board("PR9zqZtE")
        assert board.name == "Lunch Money"
      end
    end

    test "gets a board with options [actions: 'all']" do
      use_cassette "get_board_with_options" do
        board = ExTrello.board("PR9zqZtE", actions: "all")

        assert is_list(board.actions)
        assert match?([%Action{}|_], board.actions)
      end
    end

    test "gets a board with options [lists: 'all']" do
      use_cassette "get_board_with_lists" do
        board = ExTrello.board("PR9zqZtE", lists: "all")

        assert is_list(board.lists)
        assert match?([%TrelloList{}|_], board.lists)
      end
    end

    test "gets a board with options [cards: 'all']" do
      use_cassette "get_board_with_cards" do
        board = ExTrello.board("PR9zqZtE", cards: "all")

        assert is_list(board.cards)
        assert match?([%Card{}|_], board.cards)
      end
    end

  end

  describe "Fetching cards from Trello" do

    test "fetches card with specified id" do
      use_cassette "get_card_by_id" do
        card = ExTrello.card("570ddfcab92fb2f520a02361")

        assert card.name == "Write RSpecs for List model validations :)"
        assert match?(%Card{}, card)
      end
    end

    test "fetches card with specified shortlink" do
      use_cassette "get_card_by_shortlink" do
        card = ExTrello.card("IQPY44Pr")

        assert card.name == "Write RSpecs for List model validations :)"
        assert match?(%Card{}, card)
      end
    end

    test "fetches a card and its members" do
      use_cassette "get_card_with_members" do
        card = ExTrello.card("IQPY44Pr", members: true)

        assert is_list(card.members)
        assert match?([%Member{}|_], card.members)
      end
    end

  end

  describe "Fetching actions from Trello" do

    test "gets action using specified action id" do
      use_cassette "get_action" do
        action = ExTrello.action("57b248970888c3d8b59ef0db")

        assert action.type == "commentCard"
        assert action.id == "57b248970888c3d8b59ef0db"
      end
    end

  end

  describe "Creating boards on Trello" do
    test "creates a board with specified name" do
      use_cassette "create_board" do
        new_board = ExTrello.create_board("Just a name.")

        assert new_board.name == "Just a name."
        assert match?(%Board{}, new_board)
      end
    end

    test "creates a board with specified name & (optional)desc" do
      use_cassette "create_board_with_description" do
        newly_created_board = ExTrello.create_board("ExTrello", desc: "An Elixir library to wrap the Trello API")

        assert newly_created_board.name == "ExTrello"
        assert newly_created_board.desc == "An Elixir library to wrap the Trello API"
        assert match?(%Board{}, newly_created_board)
      end
    end

    test "creates board with specified name & options" do
      use_cassette "create_board_with_options" do
        board_with_options = ExTrello.create_board("Trellex", powerUps: "all") # Creating the board here
          |> (&(ExTrello.board(&1.id, fields: "all"))).() # Fetching the board with all fields so we can test our assertion

        assert board_with_options.name == "Trellex"
        assert "voting" in board_with_options.power_ups
      end
    end

  end

  describe "Creating cards on Trello" do

    test "creates card on specified list_id with specified name" do
      use_cassette "create_card_list_id_and_name" do
        card = ExTrello.create_card("57663322ac7d147b2c337e34", "Let there be card!")

        assert card.name == "Let there be card!"
        assert match?(%Card{}, card)
      end
    end

    test "creates card with specified name and options" do
      use_cassette "create_card_with_options" do
        card = ExTrello.create_card("57663322ac7d147b2c337e34", "And then there was card.", desc: "Doge saw that the card was good.")

        assert card.name == "And then there was card."
        assert card.desc == "Doge saw that the card was good."
        assert match?(%Card{}, card)
      end
    end

    test "creates card using list struct and name" do
      use_cassette "create_card_list_struct" do
        card = ExTrello.get("lists/57663322ac7d147b2c337e34")
          |> ExTrello.Parser.parse_list
          |> ExTrello.create_card("Feelin' structy")

        assert card.name == "Feelin' structy"
        assert match?(%Card{}, card)
      end
    end

  end

  describe "Creating comments on a Trello Card" do

    test "creats a comment with specified text on card with specified id" do
      use_cassette "create_comment_using_card_id" do
        comment_action = ExTrello.create_comment("57b2138403d585642725f232", "This feels like it's nearing completion.")

        assert match?(%Action{}, comment_action)
        assert comment_action.type == "commentCard"
        assert comment_action.display.entities.comment.text == "This feels like it's nearing completion."
      end
    end

    test "creats a comment with specified text on card using struct" do
      use_cassette "create_comment_using_card_struct" do
        comment_action = ExTrello.card("57b2138403d585642725f232")
          |> ExTrello.create_comment("Trelling all day")

        assert match?(%Action{}, comment_action)
        assert comment_action.type == "commentCard"
        assert comment_action.display.entities.comment.text == "Trelling all day"
      end
    end

  end

  describe "Editing boards on Trello" do

    test "edits board with specified id" do
      use_cassette "edit_board_with_id" do
        clean_board  = ExTrello.board("57b0a9692bd632657caf3859")
        edited_board = ExTrello.edit_board("57b0a9692bd632657caf3859", name: "Edited Test")

        assert clean_board.id == edited_board.id
        assert clean_board.name == "Test"
        assert edited_board.name == "Edited Test"
      end
    end

    test "edits board using board struct" do
      use_cassette "edit_board_with_struct" do
        board = ExTrello.board("57b0a9692bd632657caf3859")

        edited_board = board
          |> ExTrello.edit_board(name: board.name <> " #1", desc: "Edited using the %Board{} struct.")

        assert board.name == "Edited Test"
        assert edited_board.name == "Edited Test #1"
      end
    end

  end

  describe "Editing cards on Trello" do

    test "edits card with specified id" do
      use_cassette "edit_card_using_id" do
        original_card = ExTrello.card("57b2138403d585642725f232")
        edited_card = ExTrello.edit_card("57b2138403d585642725f232", name: "Feelin' structy part 2")

        assert original_card.name == "Feelin' structy"
        assert edited_card.name == "Feelin' structy part 2"
      end
    end

    test "edits card using card struct" do
      use_cassette "edit_card_using_struct" do
        original_card = ExTrello.card("57b2138403d585642725f232")

        assert match?(%Card{}, original_card) # Proving this is a %Card{} struct
        edited_card = ExTrello.edit_card(original_card, name: "Feelin' structy part 3")

        assert original_card.name == "Feelin' structy part 2"
        assert edited_card.name == "Feelin' structy part 3"
      end
    end

  end

  describe "Fetching cards associated with a board" do

    test "fetches cards with specified board id" do
      use_cassette "board_cards" do
        cards = ExTrello.board_cards("57663306e4b15193fcc97483")

        assert is_list(cards)
        assert match?([%Card{id: "57a90f8f732333fa17bfd341"}|_rest], cards)
      end
    end

    test "fetches cards for specified board struct & options" do
      use_cassette "board_cards_with_options" do
        # Let's get members attached to each card.
        [first_card| _other_cards] = cards = ExTrello.board("57663306e4b15193fcc97483")
          |> ExTrello.board_cards(members: true)

        assert is_list(cards)
        assert first_card.name == "This card will be at the top of the list2."
        assert match?([%Member{full_name: "Chris Yammine"}|_], first_card.members)
      end
    end

  end

  describe "Fetching Trello members" do

    test "fetches authenticated user's member record" do
      use_cassette "authenticated_member" do
        member = ExTrello.member

        assert member.full_name == "Chris Yammine"
      end
    end

    test "fetches authenticated member with boards" do
      use_cassette "authenticated_member_with_boards" do
        member = ExTrello.member(boards: "all")

        assert is_list(member.boards)
        assert match?([%Board{}|_], member.boards)
      end
    end

    test "fetches authenticated member with organizations" do
      use_cassette "authenticated_member_with_organizations" do
        member = ExTrello.member(organizations: "all")

        assert is_list(member.organizations)
        assert match?([%Organization{}|_], member.organizations)
      end
    end

    test "fetches authenticated member with several sub-resources" do
      use_cassette "authenticated_member_with_many_subresources" do
        member = ExTrello.member(actions: "all", actions_limit: 1000, cards: "all", card_members: true, boards: "all", board_actions: "all", board_lists: "all", organizations: "all")
        first_card = member.cards |> List.first
        first_board = member.boards |> List.first

        # Such assertions
        assert is_list(member.organizations)
        assert match?([%Organization{}|_], member.organizations)
        assert is_list(member.boards)
        assert match?([%Board{}|_], member.boards)
        assert is_list(member.cards)
        assert match?([%Card{}|_], member.cards)
        assert is_list(member.actions)
        assert match?([%Action{}|_], member.actions)

        # much wow
        assert is_list(first_card.members)
        assert match?([%Member{}|_], first_card.members)

        # many test
        assert is_list(first_board.lists)
        assert match?([%TrelloList{}|_], first_board.lists)
      end
    end

    test "fetches the specified member record" do
      use_cassette "get_member" do
        member = ExTrello.member("trello")

        assert member.full_name == "Trello"
      end
    end

  end

end
