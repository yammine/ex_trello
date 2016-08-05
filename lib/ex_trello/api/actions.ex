defmodule ExTrello.API.Actions do
  @moduledoc """
  Module to wrap the Actions API endpoints.
  reference: https://developers.trello.com/advanced-reference/action
  """

  import ExTrello.API.Base
  alias ExTrello.Parser

  def action(id), do: action(id, [])
  def action(id, options) when is_binary(id) and is_list(options) do
    params = Parser.parse_request_params(options)

    request(:get, "actions/#{id}", params)
    |> Parser.parse_action
  end
end
