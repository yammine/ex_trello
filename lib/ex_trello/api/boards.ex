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
  defapicall boards(options) when is_list(options) do
    request(:get, "members/me/boards", options)
    |> Enum.map(&Parser.parse_board/1)
  end
  defapicall boards(user, options \\ []) when is_binary(user) do
    request(:get, "members/#{user}/boards", options)
    |> Enum.map(&Parser.parse_board/1)
  end

  def board(id_or_struct), do: board(id_or_struct, [])
  def board(%Board{id: id}, options), do: board(id, options)
  defapicall board(id, options) when is_binary(id) do
    request(:get, "boards/#{id}", options)
    |> Parser.parse_board
  end

  def create_board(name) when is_binary(name), do: create_board(name, [])
  defapicall create_board(name, options) when is_binary(name) do
    request(:post, "boards", [{:name, name}| options])
    |> Parser.parse_board
  end

  def edit_board(%Board{id: id}, fields), do: edit_board(id, fields)
  defapicall edit_board(id, fields) when is_list(fields) do
    request(:put, "boards/#{id}", fields)
    |> Parser.parse_board
  end

  # Board Cards
  def cards(board), do: cards(board, [])
  def cards(%Board{id: id}, options), do: cards(id, options)
  defapicall cards(board_id, options) when is_binary(board_id) do
    request(:get, "boards/#{board_id}/cards", options)
    |> Enum.map(&Parser.parse_card/1)
  end

  # Board labels
  def labels(board), do: labels(board, [])
  def labels(%Board{id: id}, options), do: labels(id, options)
  defapicall labels(board_id, options) when is_binary(board_id) do
    request(:get, "boards/#{board_id}/labels", options)
    |> Enum.map(&Parser.parse_label/1)
  end

end
