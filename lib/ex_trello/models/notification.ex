defmodule ExTrello.Model.Notification do
  @moduledoc """
  A Struct that represents all possible fields a `notification` resource from Trello can be returned with.
  """
  defstruct id: nil, entities: nil, data: nil, date: nil, id_member_creator: nil, type: nil, unread: nil,
            member_creator: nil, board: nil, list: nil, card: nil, organization: nil, member: nil

  @type t :: %__MODULE__{}
end
