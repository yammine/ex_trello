defmodule ExTrello.API.Members do
  @moduledoc """
  Module to wrap Boards API endpoints.
  reference: https://developers.trello.com/advanced-reference/member
  """
  import ExTrello.API.Base
  alias  ExTrello.Parser

  def member, do: member([])
  defapicall member(options) when is_list(options) do
    request(:get, "members/me", options)
    |> Parser.parse_member
  end
  def member(id_or_username) when is_binary(id_or_username), do: member(id_or_username, [])
  defapicall member(id_or_username, options) do
    request(:get, "members/#{id_or_username}", options)
    |> Parser.parse_member
  end
end
