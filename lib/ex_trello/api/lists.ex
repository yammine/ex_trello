defmodule ExTrello.API.Lists do
  @moduledoc """
  Module to wrap Lists API endpoints.
  reference: https://developers.trello.com/advanced-reference/list
  """

  import ExTrello.API.Base
  alias  ExTrello.Parser
  alias  ExTrello.Model.{Board, List}

  def list(list_id_or_struct), do: list(list_id_or_struct, [])
  def list(%List{id: id}, options), do: list(id, options)
  def list(id, options) when is_binary(id) do
    request(:get, "lists/#{id}", options)
    |> Parser.parse_list
  end

  def create_list(board_struct_or_id, name), do: create_list(board_struct_or_id, name, [])
  def create_list(%Board{id: board_id}, name, options), do: create_list(board_id, name, options)
  def create_list(board_id, name, options) when is_binary(name) do
    request(:post, "lists", [{:name, name}, {:idBoard, board_id}|options])
    |> Parser.parse_list
  end

  def edit_list(%List{id: id}, fields), do: edit_list(id, fields)
  def edit_list(id, fields) when is_binary(id) and is_list(fields) do
    request(:put, "lists/#{id}", fields)
    |> Parser.parse_list
  end
end
