defmodule ExTrello.API.Boards do
  @moduledoc """
  Module to wrap Boards API endpoints.
  reference: https://developers.trello.com/advanced-reference/board
  """

  import ExTrello.API.Base
  alias ExTrello.Parser

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

  def create_board(name, options) when is_binary(name) and (byte_size(name) >= 1 and byte_size(name) <= 16384) do
    params = Parser.parse_request_params(options)

    request(:post, "boards", [{"name", name} | params]) # Adding name to the params list.
    |> Parser.parse_board
  end
  def create_board(name) when is_binary(name) and (byte_size(name) >= 1 and byte_size(name) <= 16384), do: create_board(name, []) # Creating a board sans options.
  def create_board(nil), do: raise_name_length_error
  def create_board(""), do:  raise_name_length_error
  def create_board(_), do:   raise_name_length_error

  def edit_board(id, fields) when is_list(fields) do
    params = Parser.parse_request_params(fields)

    request(:put, "boards/#{id}", params)
    |> Parser.parse_board
  end

  defp raise_name_length_error do
    raise(ExTrello.Error, code: 422, message: "You must provide a name with a length between 1 and 16384 to create a board.")
  end
end
