defmodule ExTrello.API.Notifications do
  @moduledoc """
  Module to wrap the Notifications API endpoints
  reference: https://developers.trello.com/advanced-reference/notification
  """

  import ExTrello.API.Base
  alias ExTrello.Parser
  alias ExTrello.Model.Notification

  def notification(id), do: notification(id, [])
  defapicall notification(id, options) when is_binary(id) and is_list(options) do
    request(:get, "notifications/#{id}", options)
    |> Parser.parse_notification
  end

  def notifications(), do: notifications([])
  defapicall notifications(options) when is_list(options) do
    request(:get, "members/me/notifications", options)
    |> Enum.map(&Parser.parse_notification/1)
  end

  def mark_read(%Notification{id: id}), do: mark_read(id)
  defapicall mark_read(id) when is_binary(id) do
    request(:put, "notifications/#{id}", unread: false)
  end

  def mark_unread(%Notification{id: id}), do: mark_unread(id)
  defapicall mark_unread(id) when is_binary(id) do
    request(:put, "notifications/#{id}", unread: true)
  end

end
