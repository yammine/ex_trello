defmodule ExTrello.Model.Card do
  @moduledoc """
  A Struct that represents all possible fields a `card` resource from Trello can be returned with.
  """
  defstruct id: nil, name: nil, id_list: nil, id_board: nil, actions: nil, attachments: nil, members: nil,
            checklists: nil, board: nil, list: nil, stickers: nil, badges: nil, check_item_states: nil,
            closed: nil, date_last_activity: nil, desc: nil, descData: nil, due: nil, email: nil,
            id_checklists: nil, id_members: nil, id_members_voted: nil, id_short: nil, id_attachment_cover: nil,
            manual_cover_attachment: nil, labels: nil, id_labels: nil, pos: nil, short_link: nil, short_url: nil,
            subscribed: nil, url: nil

  @type t :: %__MODULE__{}
end
