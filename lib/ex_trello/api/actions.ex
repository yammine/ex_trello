defmodule ExTrello.API.Actions do
  @moduledoc """
  Module to wrap the Actions API endpoints.
  reference: https://developers.trello.com/advanced-reference/action
  """

  import ExTrello.API.Base
  alias ExTrello.Parser

  def action(id), do: action(id, [])
  defapicall action(id, options) when is_binary(id) and is_list(options) do
    request(:get, "actions/#{id}", options)
    |> Parser.parse_action
  end
end
