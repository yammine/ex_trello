defmodule ExTrello.API.Boards do
  @moduledoc """
  Module to wrap Boards API endpoints.
  reference: https://developers.trello.com/advanced-reference/board
  """

  import ExTrello.API.Base
  alias  ExTrello.Parser
  alias  ExTrello.Model.{Board}

  # Boards
  def boards(), do: boards([])
  def boards(options) when is_list(options) do
    params = Parser.parse_request_params(options)

    request(:get, "members/me/boards", params)
    |> Enum.map(&Parser.parse_board/1)
  end
  def boards(user, options \\ []) when is_binary(user) do
    params = Parser.parse_request_params(options)

    request(:get, "members/#{user}/boards", params)
    |> Enum.map(&Parser.parse_board/1)
  end

  def board(id, options \\ []) when is_binary(id) do
    params = Parser.parse_request_params(options)

    request(:get, "boards/#{id}", params)
    |> Parser.parse_board
  end

  def create_board(name) when is_binary(name), do: create_board(name, [])
  def create_board(name, options) when is_binary(name) do
    params = Parser.parse_request_params [{:name, name}| options]

    request(:post, "boards", params)
    |> Parser.parse_board
  end

  def edit_board(id, fields) when is_list(fields) do
    params = Parser.parse_request_params(fields)

    request(:put, "boards/#{id}", params)
    |> Parser.parse_board
  end

  # Board Cards
  def cards(board), do: cards(board, [])
  def cards(%Board{id: id}, options), do: cards(id, options)
  def cards(board_id, options) when is_binary(board_id) do
    params = Parser.parse_request_params(options)

    request(:get, "boards/#{board_id}/cards", params)
    |> Enum.map(&Parser.parse_card/1)
  end
end
