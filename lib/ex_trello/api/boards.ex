defmodule ExTrello.API.Boards do
  @moduledoc """
  Module to wrap Boards API endpoints.
  reference: https://developers.trello.com/advanced-reference/board
  """

  import ExTrello.API.Base
  def boards(), do: boards([])
  def boards(options) when is_list(options) do
    params = ExTrello.Parser.parse_request_params(options)

    request(:get, "members/me/boards", params)
    |> Enum.map(&ExTrello.Parser.parse_board/1)
  end

  def boards(user, options \\ []) when is_binary(user) do
    params = ExTrello.Parser.parse_request_params(options)

    request(:get, "members/#{user}/boards", params)
    |> Enum.map(&ExTrello.Parser.parse_board/1)
  end
end
