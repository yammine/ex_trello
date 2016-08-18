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
    request(:get, "members/me/boards", options)
    |> Enum.map(&Parser.parse_board/1)
  end
  def boards(user, options \\ []) when is_binary(user) do
    request(:get, "members/#{user}/boards", options)
    |> Enum.map(&Parser.parse_board/1)
  end

  def board(id_or_struct), do: board(id_or_struct, [])
  def board(%Board{id: id}, options), do: board(id, options)
  def board(id, options) when is_binary(id) do
    request(:get, "boards/#{id}", options)
    |> Parser.parse_board
  end

  def create_board(name) when is_binary(name), do: create_board(name, [])
  def create_board(name, options) when is_binary(name) do
    request(:post, "boards", [{:name, name}| options])
    |> Parser.parse_board
  end

  def edit_board(%Board{id: id}, fields), do: edit_board(id, fields)
  def edit_board(id, fields) when is_list(fields) do
    request(:put, "boards/#{id}", fields)
    |> Parser.parse_board
  end

  # Board Cards
  def cards(board), do: cards(board, [])
  def cards(%Board{id: id}, options), do: cards(id, options)
  def cards(board_id, options) when is_binary(board_id) do
    request(:get, "boards/#{board_id}/cards", options)
    |> Enum.map(&Parser.parse_card/1)
  end
end
