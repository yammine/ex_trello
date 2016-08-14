defmodule ExTrelloTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock
  doctest ExTrello

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

  test "Uses the `ExTrello.get` function to hit the not-yet-implemented /search/members endpoint" do
    use_cassette "base_get_request" do
      search = ExTrello.get("search/members", query: "trello", limit: 1)

      assert Enum.count(search) == 1
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
        assert match?([%ExTrello.Model.Action{}|_], board.actions)
      end
    end

  end

  describe "Creating boards on Trello" do

    test "creates a board with specified name & (optional)desc" do
      use_cassette "create_board" do
        newly_created_board = ExTrello.create_board("ExTrello", desc: "An Elixir library to wrap the Trello API")

        assert newly_created_board.name == "ExTrello"
        assert newly_created_board.desc == "An Elixir library to wrap the Trello API"
        assert match?(%ExTrello.Model.Board{}, newly_created_board)
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
          |> ExTrello.edit_board(name: board.name <> " #1", desc: "Edited using the %ExTrello.Model.Board{} struct.")

        assert board.name == "Edited Test"
        assert edited_board.name == "Edited Test #1"
      end
    end

  end

end
