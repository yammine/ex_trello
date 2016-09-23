defmodule ExTrello.API.Checklists do
  @moduledoc """
  Module to wrap the Checklists API endpoints.
  reference: https://developers.trello.com/advanced-reference/checklist
  """

  import ExTrello.API.Base
  alias ExTrello.Parser
  alias ExTrello.Model.{Checklist}

  def checklist(id), do: checklist(id, [])
  defapicall checklist(id, options) when is_binary(id) and is_list(options) do
    request(:get, "checklists/#{id}", options)
    |> Parser.parse_checklist
  end

  def checklist_board(%Checklist{id: id}), do: checklist_board(id)
  defapicall checklist_board(id) when is_binary(id) do
    request(:get, "checklists/#{id}/board")
    |> Parser.parse_board
  end
end
