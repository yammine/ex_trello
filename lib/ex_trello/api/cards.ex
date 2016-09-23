defmodule ExTrello.API.Cards do
  @moduledoc """
  Module to wrap Cards API endpoints.
  reference: https://developers.trello.com/advanced-reference/card
  """

  import ExTrello.API.Base
  alias ExTrello.Parser
  alias ExTrello.Model.{Card, List}

  def card(id_or_shortlink), do: card(id_or_shortlink, [])
  defapicall card(id_or_shortlink, options) when is_binary(id_or_shortlink) do
    request(:get, "cards/#{id_or_shortlink}", options)
    |> Parser.parse_card
  end

  def create_card(list, name) when is_binary(name), do: create_card(list, name, [])
  def create_card(%List{id: id}, name, options) when is_binary(name), do: create_card(id, name, options)
  defapicall create_card(list_id, name, options) when is_binary(list_id) and is_binary(name) do
    params = [{:idList, list_id}, {:name, name}|options]

    request(:post, "cards", params)
    |> Parser.parse_card
  end

  def edit_card(%Card{id: id}, fields), do: edit_card(id, fields)
  defapicall edit_card(card_id_or_shortlink, fields) when is_binary(card_id_or_shortlink) do
    request(:put, "cards/#{card_id_or_shortlink}", fields)
    |> Parser.parse_card
  end

  def create_comment(%Card{id: id}, text), do: create_comment(id, text)
  defapicall create_comment(id_or_shortlink, text) when is_binary(id_or_shortlink) and is_binary(text) do
    request(:post, "cards/#{id_or_shortlink}/actions/comments", [text: text])
    |> Parser.parse_action
  end
end
