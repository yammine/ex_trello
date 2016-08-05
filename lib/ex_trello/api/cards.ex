defmodule ExTrello.API.Cards do
  @moduledoc """
  Module to wrap Cards API endpoints.
  reference: https://developers.trello.com/advanced-reference/card
  """

  import ExTrello.API.Base
  alias ExTrello.Parser
  alias ExTrello.Model.{Card}

  def card(id_or_shortlink), do: card(id_or_shortlink, [])
  def card(id_or_shortlink, options) when is_binary(id_or_shortlink) do
    params = Parser.parse_request_params(options)

    request(:get, "cards/#{id_or_shortlink}", params)
    |> Parser.parse_card
  end

  def create_comment(%Card{id: id}, text), do: create_comment(id, text)
  def create_comment(id_or_shortlink, text) when is_binary(id_or_shortlink) and is_binary(text) do
    params = Parser.parse_request_params [{:text, text}]

    request(:post, "cards/#{id_or_shortlink}/actions/comments", params)
    |> Parser.parse_action
  end
end
